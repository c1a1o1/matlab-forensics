function[] = BBAvacuousExt(filename, destModelFile, destFile)

%parse destination model
destModel = modelParser(destModelFile);

%parse file
fid = fopen(filename);
[path,file] = fileparts(filename);
fidOut = fopen(destFile,'w+');

k=1;
while 1
    tline{k} = fgetl(fid); %#ok<AGROW>
    if ~ischar(tline{k})
        break
    end
    k=k+1;
end
fLen = k;

%INTERPRETATION...

ptr=1;
%Copy initial file until reaching the model specification..
try
    while ~strcmpiis(tline{ptr},'ModelFile=') && ptr<fLen
        fprintf(fidOut, '%s\n', tline{ptr});
        ptr=ptr+1;
    end
        fprintf(fidOut, '%s\n', tline{ptr});
        fprintf(fidOut, '\t%s\n', destModelFile);
    ptr = ptr+2;
catch ME
    error(['Cannot find mandatory field "ModelFile" in BBA file ',filename]);
end


while ~strcmpiis(tline{ptr},'BBA={') && ptr<fLen
    fprintf(fidOut, '%s\n', tline{ptr});
    ptr=ptr+1;
end
    fprintf(fidOut, '%s\n', tline{ptr});
expr = '<(\w+).*?>.*?</\1>';

while ~strcmpi(tline{ptr},'}')
    line = strtrim(tline{ptr});
    if ~isempty(strfind(line,'<assignment>'))
        fprintf(fidOut, '%s\n', tline{ptr});
        tmpptr=0;
        mass = [];
        setlist=cell(1,1);
        while isempty(strfind(tline{ptr},'</assignment>'))
           ptr=ptr+1; 
           tmpptr=tmpptr+1;
        end
        tagline = [tline{ptr-tmpptr+1:ptr-1}];
        [tok mat] = regexp(tagline, expr, 'tokens', 'match');
        %now parse tokens
        s=1;
        for j=1:length(mat)
            parsed = mat{j}(length(tok{1,j}{1,1})+3:end-(length(tok{1,j}{1,1})+3));
            if strcmpi(tok{1,j}{1,1},'mass')
                %copy mass assignemnt
                fprintf(fidOut,'\t\t\t%s\n',mat{j});    
                    
            elseif strcmpi(tok{1,j}{1,1},'set')
                %PERFORM EXTENSION
                %search for compatible events in target model
                extended = findExtension(parsed, destModel);
                for v=1:numel(extended)
                    %write events 
                    fprintf(fidOut,'\t\t\t<set>%s</set>\n',extended{v});    
                end
            end
        end
        %close assignment tag
        fprintf(fidOut,'\t\t</assignment>\n');
        ptr=ptr-1;
        
    end
    ptr=ptr+1;
end
%close BBA declaration
fprintf(fidOut,'\t}\n');

%close files
fclose(fid);
fclose(fidOut);
end
%emptyset = ['s' repmat('0',1,length(ass1{1})-1)];

% function[ext]=findExtension(event, model)
%     k=1;
%     for i=1:numel(model.EventList)
%         if strcmpiis(event(1:end-1),  model.EventList(i).EventName(1:length(event)-1))
%            display(sprintf('Will map %s in %s', event, model.EventList(i).EventName)); 
%            ext{k} = model.EventList(i).EventName; %#ok<AGROW>
%            k=k+1;
%         end
%     end
% end

function[ext]=findExtension(event, model)
    k=1;
    %get sub-event list of event
    listEvent = splitSubEvents(event);
    for i=1:numel(model.EventList)
        %get sub-event list of candidate
        listCandidate = splitSubEvents(model.EventList(i).EventName);
        %check if listEvent is subset of listCandidate
        match=0;
        for e=1:length(listEvent)
            for c=1:length(listCandidate)
                if strcmpiis(listEvent{e},listCandidate{c})
                    match=match+1;
                end
            end
        end
        if match==length(listEvent)
           %display(sprintf('Will map %s in %s', event, model.EventList(i).EventName)); 
           ext{k} = model.EventList(i).EventName; %#ok<AGROW>
           k=k+1;
        end
    end
end

function[list] = splitSubEvents(eventName)
    %remove brackets
    eventName = strrep(eventName,'(','');
    eventName = strrep(eventName,')','');
    %cut string and remove spaces
    list = strtrim(regexp(eventName, ',', 'split'));
end

function[string] = strcmpiis(string1, string2)
    tmp1 = strrep(string1,' ','');
    tmp2 = strrep(string2,' ','');
    string = strcmpi(tmp1,tmp2);
end