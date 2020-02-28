function task_HTT_TILS_20x(hObj)
try
    
    handles = guidata(hObj);
    myData = handles.myData;
    taskinfo = myData.taskinfo;
    calling_function = handles.myData.taskinfo.calling_function;
    
    display([taskinfo.task, ' called from ', calling_function])
    
    switch calling_function
        
        case 'Load_Input_File' % Read in the taskinfo
            
            taskinfo_default(hObj, taskinfo)
            handles = guidata(hObj);
            taskinfo = handles.myData.taskinfo;
            desc = taskinfo.desc;  
            taskinfo.rotateback = 0;
            taskinfo.showingROI = 1;
            if length(taskinfo.desc)>9
                myData.finshedTask = myData.finshedTask + 1;
            end
        case {'Update_GUI_Elements', ...
                'ResumeButtonPressed'} % Initialize task elements
            
            % Load the image
            ROIname = [handles.myData.task_images_dir, taskinfo.id, '.tif'];
            taskinfo.ROIname = ROIname;
            taskinfo.showingROI = 1;
            handles.myData.taskinfo = taskinfo;
            guidata(hObj, handles);
            taskimage_load_halfscale(hObj);
            handles = guidata(hObj);

            % Show management buttons
            taskmgt_default(handles, 'on');
            handles = guidata(hObj);
            
            % question 1
            handles.question1panel = uibuttongroup('Parent',handles.task_panel,...
                'Position',[0.1,0.7,0.8,0.1],...
                'visible','on');
            
            handles.question1text = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.1,0.8,0.8,0.1], ...
                'Style', 'text', ...
                'Tag', 'textCount', ...
                'String', '1. How would you label this ROI?');
            
            
            handles.radiobutton1A = uicontrol(...
                'Parent', handles.question1panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0,0,0.25,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton1A', ...
                'String', 'Intra-tumoral stroma');
            
            handles.radiobutton1B = uicontrol(...
                'Parent', handles.question1panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.25,0,0.25,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton1B', ...
                'String', 'Tumor with NO intervening stroma');

            handles.radiobutton1C = uicontrol(...
                'Parent', handles.question1panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.5,0,0.25,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton1C', ...
                'String', 'Invasive margin (1mm)');

            handles.radiobutton1D = uicontrol(...
                'Parent', handles.question1panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.75,0,0.25,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton1D', ...
                'String', 'Other');

            
            set(handles.question1panel, ...
                'SelectionChangeFcn', @radiobutton1_Callback, ...
                'SelectedObject', []);
            
            % question 2
            
            handles.question2panel = uibuttongroup('Parent',handles.task_panel,...
                'Position',[0.3,0.45,0.5,0.1],...
                'visible','on');
            
            handles.question2text = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.1,0.55,0.8,0.1], ...
                'Style', 'text', ...
                'Tag', 'textCount', ...
                'String', '2: Is this ROI appropriate to evaluate intra-tumoral stromal TIL density?');
            
            handles.radiobutton2T = uicontrol(...
                'Parent', handles.question2panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0,0,0.5,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton2T', ...
                'String', 'True');
            
            handles.radiobutton2F = uicontrol(...
                'Parent', handles.question2panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.5,0,0.5,1], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton2F', ...
                'String', 'False');
            
            set(handles.question2panel, ...
                'SelectionChangeFcn', @radiobutton2_Callback, ...
                'SelectedObject', []);
            
            % question 3
            handles.question3text = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [.1, .3, .8, .1], ...
                'Style', 'text', ...
                'Enable','off',...
                'Tag', 'textCount', ...
                'String', '3: What is the intra-tumoral stromal TIL density?');
            
            initvalue = 50;
            slider_x = .1;
            slider_y = .1;
            slider_w = .55;
            slider_h = .1;
            position = [slider_x, slider_y, slider_w, slider_h];
            handles.slider = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', position, ...
                'Style', 'slider', ...
                'Tag', 'slider', ...
                'String', 'slider_string', ...
                'Min', 0, ...
                'Max', 100, ...
                'SliderStep', [1.0/100.0, .1], ...
                'Value', initvalue, ...
                'Enable','off',...
                'Callback', @slider_Callback);

            position = [slider_x, slider_y+slider_h, .1, .1];
            handles.textleft = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'Tag', 'textleft', ...
                'String', '0');

            position = [slider_x+slider_w/2-.05, slider_y+slider_h, .1, .1];
            handles.textcenter = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'Tag', 'textcenter', ...
                'String', '50');

            position = [slider_x+slider_w-.1, slider_y+slider_h, .1, .1];
            handles.textright = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'Tag', 'textright', ...
                'String', '100');
            
            
            position = [slider_x+slider_w+.05, slider_y, .1, slider_h];
            handles.editvalue = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', position, ...
                'Style', 'edit', ...
                'Enable','off',...
                'Tag', 'editvalue', ...
                'String', num2str(initvalue), ...
                'Callback', @editvalue_Callback);

            position = [slider_x+slider_w+.05, slider_y+slider_h, .1, .1];
            handles.textscore = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'Tag', 'textright', ...
                'String', 'Score');
             
            % switch ROI
            handles.switchROI = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'ForegroundColor',  handles.myData.settings.FG_color, ...
                'BackgroundColor',  handles.myData.settings.BG_color, ...
                'Position',[0.85,0.85,0.15,0.15], ...
                'Style', 'pushbutton', ...
                'Tag', 'editvalue', ...
                'Enable','on',...
                'visible','on',...
                'String', 'Switch to WSI thumbnail',...
                'Callback',@switchROI_Callback);
            
        case {'NextButtonPressed', ...
                'PauseButtonPressed',...
                'Backbutton_Callback',...
                'Refine_Register_Button_Callback'} % Clean up the task elements
            
            % Hide image and management buttons
            taskmgt_default(handles, 'off');
            handles = guidata(hObj);
            set(handles.iH,'visible','off');
            set(handles.ImageAxes,'visible','off');
            delete(handles.question1text);
            delete(handles.question1panel);
            delete(handles.radiobutton1A);
            delete(handles.radiobutton1B);
            delete(handles.radiobutton1C);
            delete(handles.radiobutton1D);
            
            delete(handles.question2text);
            delete(handles.question2panel);
            delete(handles.radiobutton2T);
            delete(handles.radiobutton2F);
            
            delete(handles.question3text);
            delete(handles.slider);
            delete(handles.editvalue);
            delete(handles.textleft);
            delete(handles.textcenter);
            delete(handles.textright);
            delete(handles.textscore);
            
            delete(handles.switchROI);

            
            handles = rmfield(handles, 'question2text');
            handles = rmfield(handles, 'question1panel');
            handles = rmfield(handles, 'radiobutton1A');
            handles = rmfield(handles, 'radiobutton1B');
            handles = rmfield(handles, 'radiobutton1C');
            handles = rmfield(handles, 'radiobutton1D');
            
            handles = rmfield(handles, 'question1text');
            handles = rmfield(handles, 'question2panel');
            handles = rmfield(handles, 'radiobutton2T');
            handles = rmfield(handles, 'radiobutton2F');
            
            handles = rmfield(handles, 'question3text');
            handles = rmfield(handles, 'slider');
            handles = rmfield(handles, 'editvalue');
            handles = rmfield(handles, 'textleft');
            handles = rmfield(handles, 'textcenter');
            handles = rmfield(handles, 'textright');
            handles = rmfield(handles, 'textscore');
            
            handles = rmfield(handles, 'switchROI');
            
            taskimage_archive(handles);
            
        case 'exportOutput' % export current task information and reuslt
            if taskinfo.currentWorking ==1 % write finish task in current study
                fprintf(myData.fid, [...
                    taskinfo.task, ',', ...
                    taskinfo.id, ',', ...
                    num2str(taskinfo.order), ',', ...
                    num2str(taskinfo.slot), ',',...
                    num2str(taskinfo.roi_x), ',',...
                    num2str(taskinfo.roi_y), ',', ...
                    num2str(taskinfo.roi_w), ',', ...
                    num2str(taskinfo.roi_h), ',', ...
                    taskinfo.text, ',', ...
                    num2str(taskinfo.duration), ',', ...
                    num2str(taskinfo.question1result), ',', ...
                    taskinfo.question2result, ',', ...
                    taskinfo.question3result]);
            elseif taskinfo.currentWorking ==0 % write undone task
                fprintf(myData.fid, [...
                    taskinfo.task, ',', ...
                    taskinfo.id, ',', ...
                    num2str(taskinfo.order), ',', ...
                    num2str(taskinfo.slot), ',',...
                    num2str(taskinfo.roi_x), ',',...
                    num2str(taskinfo.roi_y), ',', ...
                    num2str(taskinfo.roi_w), ',', ...
                    num2str(taskinfo.roi_h), ',', ...
                    taskinfo.text]);
            else                               % write done task from previous study
                desc = taskinfo.desc;
                for i = 1 : length(desc)-1
                    fprintf(myData.fid,[desc{i},',']);
                end
                fprintf(myData.fid,[desc{length(desc)}]);
            end            
            fprintf(myData.fid,'\r\n');
            handles.myData.taskinfo = taskinfo;
            guidata(handles.GUI, handles);   

            
    end

    % Update handles.myData.taskinfo and pack
    myData.taskinfo = taskinfo;
    handles.myData = myData;
    guidata(hObj, handles);

catch ME
    error_show(ME)
end
end

function radiobutton1_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    taskinfo.button_desc = get(eventdata.NewValue, 'Tag');
    switch taskinfo.button_desc
        case 'radiobutton1A'
            taskinfo.question1result = 1;
        case 'radiobutton1B'
            taskinfo.question1result = 2;
        case 'radiobutton1C'
            taskinfo.question1result = 3;
        case 'radiobutton1D'
            taskinfo.question1result = 4;
    end

    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end

end


function radiobutton2_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    taskinfo.button_desc = get(eventdata.NewValue, 'Tag');
    switch taskinfo.button_desc
        case 'radiobutton2T'
            taskinfo.question2result = 'T';
        case 'radiobutton2F'
            taskinfo.question2result = 'F';
    end

    % Enable next button
    if strcmp(taskinfo.question2result, 'T')
        set(handles.question3text,'Enable','on');
        set(handles.slider,'Enable','on');
        set(handles.textleft,'Enable','on');
        set(handles.textcenter,'Enable','on');
        set(handles.textright,'Enable','on');
        set(handles.editvalue,'Enable','on');
        set(handles.textscore,'Enable','on');
        set(handles.NextButton,'Enable','off');
    else
        set(handles.NextButton,'Enable','on');
        set(handles.question3text,'Enable','off');
        set(handles.slider,'Enable','off');
        set(handles.textleft,'Enable','off');
        set(handles.textcenter,'Enable','off');
        set(handles.textright,'Enable','off');
        set(handles.editvalue,'Enable','off');
        set(handles.textscore,'Enable','off');
        taskinfo.question3result = 'NA';
        uicontrol(handles.NextButton);
    end
    

    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end

end




function slider_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    set(handles.slider, 'BackgroundColor', [.95, .95, .95]);

    score = round(get(hObj, 'Value'));
    set(handles.editvalue, 'String', num2str(score));
    set(handles.NextButton, 'Enable', 'on');
    uicontrol(handles.NextButton);
    
    taskinfo.question3result = num2str(score);
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
catch ME
    error_show(ME)
end

end


function editvalue_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    score = str2double(get(handles.editvalue, 'String'));

    if score > 100
        score = 100;
        set(handles.editvalue, 'String', '100');
        set(handles.slider, 'Value', 100);
    elseif score < 0
        score = 0;
        set(handles.editvalue, 'String', '0');
        set(handles.slider, 'Value', 0);
    end
    
    set(handles.slider, ...
        'BackgroundColor', [.95, .95, .95], ...
        'Value', score);
    set(handles.NextButton,'Enable','on');
    uicontrol(handles.NextButton);
    
    % Pack the results
    taskinfo.question3result = num2str(score);
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function switchROI_Callback(hObj, eventdata) %#ok<DEFNU>
    handles = guidata(hObj);
    myData = handles.myData;
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
    if taskinfo.showingROI == 0
        ROIname = [handles.myData.task_images_dir, taskinfo.id, '.tif'];
        taskinfo.ROIname = ROIname;
        taskinfo.showingROI = 1;
        set(handles.switchROI,'String','Switch to WSI thumbnail');
        myData.taskinfo = taskinfo;
        myData.tasks_out{myData.iter} = taskinfo;
        handles.myData = myData;
        guidata(hObj, handles);
        taskimage_load_halfscale(hObj);
    else
        wsi_info = myData.wsi_files{taskinfo.slot};
        WSIfile=wsi_info.fullname;
        slideIndex = strfind(WSIfile,'\');
        fileName = WSIfile((slideIndex(end)+1): end);
        dotIndex = strfind(fileName,'.');
        fileName = fileName(1: (dotIndex(end)-1));       
        ROIname = [handles.myData.task_images_dir, fileName, '_thumb.tif'];
        taskinfo.ROIname = ROIname;
        taskinfo.showingROI = 0;
        set(handles.switchROI,'String','Switch to ROI');
        
        if ~isfile(ROIname)        
            roi_w = max(wsi_info.wsi_w);
            roi_h = max(wsi_info.wsi_h);
            roi_x = floor(roi_w/2+1);
            roi_y = floor(roi_h/2+1);
            Left = 1;
            Top  = 1;
            mp = get(0, 'MonitorPositions');
            screensize= mp(find(mp(:,1)==1&mp(:,2)==1),:);
            if  roi_w/ roi_h>(screensize(4)*0.8)/screensize(3); 
                img_w = floor(screensize(4)*0.7)/2;
                img_h = 0;
            else
                img_w = 0;
                img_h = floor(screensize(3)*0.9)/2;
            end
            WSIfile=wsi_info.fullname;
            success = ExtractROI_BIO(wsi_info, WSIfile, ROIname,...
                        Left, Top, roi_w, roi_h,...
                        img_w, img_h,...
                        handles.myData.settings.RotateWSI,...
                        wsi_info.rgb_lut);                
        end
        myData.taskinfo = taskinfo;
        myData.tasks_out{myData.iter} = taskinfo;
        handles.myData = myData;
        guidata(hObj, handles);
        taskimage_load(hObj);
     end
     
     handles = guidata(hObj);

end
