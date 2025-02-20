{................................................................................................................
    Chila360.ps
    Description:
        Altium Designer DelphiScript to generate a database of all components in the libraries with access to Git.

    License:    MIT
    Copywrite:  FEB 2025
    Version:    2.1
    Maintainer: Shahim Vedaei <shahim.vedaei@gmail.com>

    Refs:
    [1] https://www.altium.com/documentation/altium-dxp-developer/
    [2] https://www.altium.com/documentation/altium-designer/commands-reference-ad

    TODO:
    ----------------------------------------------------------------------------------------------------------
    PRI  |  Description
    ----------------------------------------------------------------------------------------------------------
    1    |   Use TRY to read/write to csv file, as it may not open properly and throw an error.
    2    |   When we press find the previous search should be halted, otherwise, on large DB we have issue.
    2    |   .package what is this? in parameters
    2    |   Cleancoding
    4    |   Updateing existing DB based on last-modified field
    4    |   Check the output of RunApplicationAndWAit
    4    |   Investigate DLL usage
    4    |   Investigate the use of DBLib, what are the limitations?
    4    |   Change the color/font of the match text in listView
    4    |   Load/Save from/to ini file more systematic. ex. read a list of updated parameter, then load/save accordingly.

................................................................................................................}


// TODO: is it possible to make variable global/const?
{..............................................................................}

// getParams
//     return: list all available parameters
function getParams: String;
var
    params      : String;
begin
    // Hint: Add '.' if it is a parametes
    params := 'NAME,TYPE,DESCRIPTION,PATH,HEIGHT,.MANF,.MANF_P#,.PARAM,.PARAM2,.VALUE';
    Result := params;
end;
{..............................................................................}

{..............................................................................}
// TODO: rename to getMaxParams
function getCountParams: Integer;
var
    params_list : TStringList;
    params      : String;
    count         : Integer;
begin
    // TODO: This funciton can be implemented in a simpler way
    params := getParams;

    params_list := TStringList.Create;
    params_list.Delimiter := ',';
    params_list.StrictDelimiter := True;
    params_list.DelimitedText := params;
    count := params_list.Count;
    params_list.free;

    Result := count;
end;
{..............................................................................}

{..............................................................................}
// isParamExist
//     param: parameter name to check
//     return: index of parameter, -1 if not exists
function isParamExist(param: String): Integer;
var
    params_list : TStringList;
    params      : String;
    inx         : Integer;
begin
    // TODO: fix spacing issue
    params := getParams;

    params_list := TStringList.Create;
    params_list.Delimiter := ',';
    params_list.StrictDelimiter := True;
    params_list.DelimitedText := params;

    inx := params_list.IndexOf(param);

    params_list.free;

    Result := inx;
end;
{..............................................................................}

{..............................................................................}
function utl_prepPathStr(path : String, sf: Boolean): String;
begin
    if (length(path) > 0) then
    begin

        if (sf = True) then
        begin
             if (path[length(path)] = '\') then
             begin
                 Result := path;
             end
             else
                 Result := path + '\';
        end // if sf = True
        else
        begin
             // remove the /\ if necessary
             if (path[1] = '\') or (path[1] = '/') then
             begin
                 Result := Copy(path, 2, Length(path) - 1)
             end
             else
                 Result := path;
        end; //if sf = False
    end // if length(path)
end;
{..............................................................................}

{..............................................................................}
function utl_prepUrlStr(path : String): String;
begin
    if (length(path) > 0) then
    begin
        if (path[length(path)] = '/') then
        begin
            Result := path;
        end
        else
            Result := path + '/';
    end // if length(path)
end;
{..............................................................................}

{..............................................................................}
function utl_getListViewLibURL: String;
var
    url : String;
begin
    // TODO: Check total num of colums before that
    url := ListView1.Columns[getCountParams].Caption;
    if (length(url) > 0) then
    begin
        Result := utl_prepUrlStr(url);
    end
    else
        MessageDlg('DB broken, could not find url', mtError, MkSet(mbOK), 0);
end;
{..............................................................................}

{..............................................................................}
function utl_getLibPathInCache (libName: String): String;
var
    cacheDir : String;
    libPath  : String;
begin
    cacheDir := utl_prepPathStr(Edit_cacheDir.Text, True);

    if (length(libName) > 0) then
    begin
        libPath := cacheDir + utl_prepPathStr(libName, false);
        libPath := StringReplace(libPath, '\', '/', MkSet(rfReplaceAll));
        Result := libPath
    end
    else
        MessageDlg('DB broken, PATH is empty', mtError, MkSet(mbOK), 0);
end;
{..............................................................................}

{..............................................................................}
// utl_getListViewItem
//    - As listview item/caption/subitem needs mapping, this function helps to
//    - parse listview items accordingly
function utl_getListViewItem (item : TListItem; ind: integer): String;
begin
    if (item <> nil) then
    begin
        if (ind < 0) then
        begin
           Result := '';
        end
        else if (ind = 0) then
        begin
           Result := item.caption;
        end
        else
           Result := item.SubItems[ind-1];
    end;
end;
{..............................................................................}

{..............................................................................}
// Form_saveSettings
//   - Auto save setting configurations
//   - This function shall be added at onExit event for necessary objects
procedure TForm1.Form_saveSettings(Sender: TObject);
var
  Ini           : TIniFile;
  iniFile       : String;
  settings_list : TStringList;
  i             : Integer;
  updateFlag    : boolean;
begin
   // INI file object
  iniFile := IncludeTrailingPathDelimiter(GetEnvVar('APPDATA')) + 'Altium\chila360_settings.ini';

  // Check the changes
  updateFlag := False;
  settings_list := TStringList.Create;
  settings_list.Delimiter := '=';
  settings_list.StrictDelimiter := True;

  if Memo_settings.Lines.Count < 2 then
     updateFlag := True;

  // TODO: is there any better way to make it systematic, rather than compare one-by-one
  for i := 0 to Memo_settings.Lines.Count - 1 do
  begin
     if updateFlag = True then
        break;

     settings_list.DelimitedText := Memo_settings.Lines[i];
     if settings_list.count > 1 then
     begin
        case settings_list[0] of
           'dburl':
              begin
                 if settings_list[1] <> Edit_dburl.Text then
                    updateFlag := True;
              end;
           'dbPath':
              begin
                 if settings_list[1] <> Edit_dbpath.Text then
                    updateFlag := True;
              end;
           'libsearchdir':
              begin
                 if settings_list[1] <> Edit_libsearchdir.Text then
                    updateFlag := True;
              end;
           'libdbsaveto':
              begin
                 if settings_list[1] <> Edit_dbsaveto.Text then
                    updateFlag := True;
              end;
           'liburl':
              begin
                 if settings_list[1] <> Edit_liburl.Text then
                    updateFlag := True;
              end;
        else // Inifile broken, each line should have correct header
            updateFlag := True;
        end; // case
     end; // if settings_list.count > 1
  end; // for Memo_settings.Lines.Count
  settings_list.Free;

  // Check ini file path
  if not DirectoryExists(ExtractFileDir(iniFile)) then
  begin
     try
        if not ForceDirectories(ExtractFileDir(iniFile)) then
           exit;
        if not DirectoryExists(ExtractFileDir(iniFile)) then // double check
           exit;
     finally
     end;
  end;

  // Save Ini file
  if updateFlag = True then
  begin
      // Save info
      Ini := TIniFile.Create(iniFile);
      try
        // Write values to the INI file
        Ini.WriteString('Windows', 'dburl', Edit_dburl.Text);
        Ini.WriteString('Windows', 'dbPath', Edit_dbpath.Text);
        Ini.WriteString('Windows', 'libsearchdir', Edit_libsearchdir.Text);
        Ini.WriteString('Windows', 'libdbsaveto', Edit_dbsaveto.Text);
        Ini.WriteString('Windows', 'liburl', Edit_liburl.Text);
        Memo_settings.Clear;
        Memo_settings.Lines.LoadFromFile(iniFile);
      finally
        Ini.Free; // Always free the object to avoid memory leaks
      end; // try
  end; // if updateFlag

end;
{..............................................................................}

{..............................................................................}
// Form_loadSettings
//   - Load the setting configuration of the app during the startup
//   - This function shall be added at onShow event of the TForm
procedure TForm1.Form_loadSettings(Sender: TObject);
var
   iniFile      : string;
   Ini          : TIniFile;
begin
   iniFile := IncludeTrailingPathDelimiter(GetEnvVar('APPDATA')) + 'Altium\chila360_settings.ini';
   if FileExists(iniFile) then
   begin

       Ini := TIniFile.Create(iniFile);
       try
         // Read values, with default values if the key doesn't exist
         Edit_dburl.Text := Ini.ReadString('Windows', 'dburl', 'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main/DB.csv');
         Edit_dbpath.Text := Ini.ReadString('Windows', 'dbPath', 'D:\');
         Edit_libsearchdir.Text := Ini.ReadString('Windows', 'libsearchdir', 'D:\');
         Edit_dbsaveto.Text := Ini.ReadString('Windows', 'libdbsaveto', 'D:\');
         Edit_liburl.Text := Ini.ReadString('Windows', 'liburl', 'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main/');
         // load settings to memo_settings for future check analysis
         Memo_settings.Lines.LoadFromFile(iniFile);
       finally
         Ini.Free;
       end;
   end;

end;
{..............................................................................}

{..............................................................................}
// RunPythonScript
//     - Run a Python script and get the output
//     args: string, the arguments to pass to the Python script
//     res: string, the output of the Python script
procedure RunPythonScript(const args: string; out res: string);
var
    OutputFile: string;
    FileContent: string;
    Command, pyExe, pyScript: String;
    Document         : IServerDocument;
    Lines: TStringList;
    i: Integer;
begin
    OutputFile := '.\output.txt';
    // Command to run Python script and redirect output to a file
    pyExe := 'python';
    pyScript := '"' + ExtractFilePath(ParamStr(0)) + 'Chila360_utils.py"';
    Command := pyExe + ' ' + pyScript + ' ' + args;
    // Run the Python script using RunApplication
    RunApplicationAndWAit(Command, 100000);

    // TODO: future: read response
    {
    // Read the output file
    Lines := TStringList.Create;
    if FileExists(OutputFile) then
    begin
        try
          Lines.LoadFromFile(OutputFile);
          res := Lines[0];
        finally
          // Free the TStringList after use
          Lines.Free;
        end;
    end;
    // TODO: shouldn't we use RESULT:=?
    }
end;
{..............................................................................}

{..............................................................................}
// utl_downloadFunc
//     - Download a file from a URL
//     url: string, the URL to download
//     saveto: string, the full filename path to save the downloaded file.
procedure utl_downloadFunc (url: String; savePath : String);
var
    args   : String;
    res    : String;
begin
    args := '--action=download_url --url=' + url + ' --saveto=' + savePath;

    StatusBar1.Panels[0].Text := 'Downloading...';
    RunPythonScript(args, res);
    StatusBar1.Panels[0].Text := 'Download completed.';
    Memo1.Lines.Add('Download: ' + url + ', to ' + savePath + ' complited.');

end;
{..............................................................................}

{..............................................................................}
// DBPostprocessing
//     - Post processing the DB file. Altium script has a limitation to perform some tasks.
//     - So, we need to use Python to do some tasks.
//     db_file: string, the path to the DB file
//     lib_dir: string, the path to the libraries
procedure DBPostprocessing(const db_file: string; const lib_dir: string);
var
   args : String;
   res : String;
begin
     args := '--action=db_postprocess' + ' --db_file=' + db_file + ' --lib_dir=' + lib_dir;
     RunPythonScript(args, res);
end;
{..............................................................................}

{..............................................................................}
// Button_dbfetchClick
procedure TForm1.Button_dbfetchClick(Sender: TObject);
var
    cacheDir :  String;
begin
    cacheDir := utl_prepPathStr(Edit_cacheDir.Text, True);
    if not DirectoryExists(cacheDir) then
    begin
        Showmessage('ERROR: Cache dir does not exist.');
        exit;
    end;

    StatusBar1.Panels[0].Text := 'Fetching DB ...';
    utl_downloadFunc(Edit_dburl.Text, cacheDir);
    StatusBar1.Panels[0].Text := 'Fetch DB completed.';
end;
{..............................................................................}

{..............................................................................}
procedure SetHeaderViewlist(const url: string);
var
    params_list : TStringList;
    params      : String;
    i           : Integer;
begin
    // Add columns
    // Set ListView to Report mode
    ListView1.ViewStyle := vsReport;
    // Ensure Full Columns are visible
    ListView1.Columns.Clear; // Clear any existing columns
    ListView1.Items.Clear;

    params := getParams;
    params_list := TStringList.Create;
    params_list.Delimiter := ',';
    params_list.StrictDelimiter := True;
    params_list.DelimitedText := params;

    for i := 0 to params_list.Count - 1 do
    begin
        with ListView1.Columns.Add do
        begin
          Caption := params_list[i];
          Width := 100; // Adjust width
        end;
    end;

    // Add repo URL
    with ListView1.Columns.Add do
    begin
      Caption := url;
      Width := 400;
    end;
end;
{..............................................................................}

{..............................................................................}
procedure Add_viewlist(const info: TStringList);
var
    Item: TListItem;
    i   : Integer;
begin
    // Add first row
    Item := ListView1.Items.Add;
    if info.count > 1 then
    begin
        Item.Caption := info[0];
        for i := 1 to info.count - 1 do
            Item.SubItems.Add(info[i]);
    end;
    // TODO: do we really need to?
    //ListView1.Invalidate;  // Force refresh
    //ListView1.Repaint;
    Application.ProcessMessages;
end;
{..............................................................................}

{..............................................................................}
// utl_csvItemPrep
//     - Items placed on a csv file shall be preprocessed to have a correct format
//     Return: formated string
function utl_csvItemPrep(const item: string): String;
var
    buf    :  string;
begin
    buf := item;
    // Preprocess csv items
    if (Pos(',', buf) > 0) or (Pos('"', buf) > 0) then
    begin
         buf := StringReplace(buf, '"', '""', MkSet(rfReplaceAll));
         buf := '"' + buf + '"';
    end;
    Result := buf;
end;

{..............................................................................}
procedure SaveListViewToCSV(ListView: TListView; const FileName: string);
var
    CSVFile: TextFile;
    i, j: Integer;
    Line: string;
begin
    AssignFile(CSVFile, FileName);
    try
        Rewrite(CSVFile);

        // Write column headers
        Line := '';
        for i := 0 to ListView.Columns.Count - 1 do
        begin
            Line := Line + utl_csvItemPrep(ListView.Columns[i].Caption);
            if i < ListView.Columns.Count - 1 then
                Line := Line + ',';
            end;
            Writeln(CSVFile, Line);

            // Write ListView items
            for i := 0 to ListView.Items.Count - 1 do
            begin
                Line := utl_csvItemPrep(ListView.Items[i].Caption); // First column

                // Add subitems
                for j := 0 to ListView.Items[i].SubItems.Count - 1 do
                    Line := Line + ',' + utl_csvItemPrep(ListView.Items[i].SubItems[j]);

                Writeln(CSVFile, Line);
            end;

    finally
        CloseFile(CSVFile);
    end;
end;
{..............................................................................}

{..............................................................................}
// UI: Button_libdownloadClick
procedure TForm1.Button_libdownloadClick(Sender: TObject);
var
    SelectedItem  : TListItem;
    url           : string;
    libPath       : String;
begin
    if ListView1.Selected <> nil then
    begin
        SelectedItem := ListView1.Selected;
        url := utl_getListViewLibURL + utl_getListViewItem(SelectedItem, isParamExist('PATH'));
        libPath := utl_getLibPathInCache(utl_getListViewItem(SelectedItem, isParamExist('PATH')));

        if FileExists(libPath) then
        begin
           if MessageDlg(libPath + ' already existed. Do you want to download? ' + url, mtConfirmation, MkSet(mbYes, mbNo), 0) = mrNo then
              exit;
        end; // if FileExists(libPath)

        utl_downloadFunc (url, libPath);
    end
    else
        MessageDlg('Select an item first', mtInformation, MkSet(mbOK), 0);
end;
{..............................................................................}

{..............................................................................}
procedure ReadSCHLIB(const FileName: string; db_path: string; lib_path: string);
var
    SCHLIB_sel          : ISch_Lib;
    SCHLIB_iter         : ISCH_Iterator;
    SCHLIB_component    : ISch_Component;
    Document            : IServerDocument;
    lib_rel_path        : TextFile;
    // Extract Parameters
    info                : TStringList;
    param               : ISch_Parameter;
    param_iter          : ISch_Iterator;
    inx                 : Integer;
    i                   : Integer;
    FileDateTime        : String;
    FileTimeStamp       : Integer;
begin
    // Hint: We may also use SchServer.CreateLibCompInfoReader(FileName) instead.
    Document := Client.OpenDocument('SCHLIB', FileName);
    If Document <> Nil Then
    Begin
        SCHLIB_sel := SchServer.GetSchDocumentByPath(Document.FileName);
        If SCHLIB_sel <> Nil Then
        begin
            SCHLIB_iter := SCHLIB_sel.SchLibIterator_Create;
            SCHLIB_iter.AddFilter_ObjectSet(MkSet(eSchComponent));
            Try
                SCHLIB_component := SCHLIB_iter.FirstSchObject;
                While SCHLIB_component <> Nil Do
                Begin
                    lib_rel_path := StringReplace(ExtractRelativePath(lib_path, FileName), '\', '/', MkSet(rfReplaceAll));
                    // Clear info
                    info := TStringList.Create;
                    for i := 0 to getCountParams do
                        info.Add('');
                    // Set Component Description
                    info[isParamExist('NAME')] := SCHLIB_component.LibReference;
                    info[isParamExist('PATH')] := lib_rel_path;
                    info[isParamExist('TYPE')] := 'SCHLIB';
                    info[isParamExist('DESCRIPTION')] := SCHLIB_component.ComponentDescription;
                    // Last modified date
                    FileTimeStamp := FileAge(FileName);
                    if FileTimeStamp > 0 then
                    begin
                      info[getCountParams] := DateTimeToStr(FileDateToDateTime(FileTimeStamp));
                    end
                    else
                      info[getCountParams] := 'ERR';
                    // Hint: SCHLIB_component.-> LibraryIdentifier/GetState_DatabaseTableName/DesignItemId/LibReference/LibraryIdentifier
                    // Extract parameters
                    Try
                        param_iter := SCHLIB_component.SchIterator_Create;
                        param_iter.AddFilter_ObjectSet(MkSet(eParameter));
                        param := param_iter.FirstSchObject;
                        While param <> Nil Do
                        Begin
                            // Hint: intentionaly adding '.' to identify parameters
                            inx := isParamExist('.' + param.Name);
                            if (inx <> -1) then
                                info[inx] := param.Text;
                            param := param_iter.NextSchObject;
                        End;
                    Finally
                        SCHLIB_component.SchIterator_Destroy(param_iter);
                    End;  // Extract parameters
                    // TODO: fixme
                    Add_viewlist(info);
                    SCHLIB_component := SCHLIB_iter.NextSchObject;
                End;
            Finally
                SCHLIB_sel.SchIterator_Destroy(SCHLIB_iter);
            End;
        end;
        // SchServer.DestroySchLibrary(SCHLIB_sel);
        //SCHLIB_sel.FreeAllContainedObjects;
        Client.CloseDocument(Document);
        //Document.ReleaseDataFileHandle;
        //Client.ClearMemorySnapshots;
    end;
end;
{..............................................................................}

{..............................................................................}
procedure ReadPCBLIB(const FileName: string; db_path: string; lib_path: string);
var
    // PCBLIB var
    PCBLIB_sel          : IPCB_Library;
    PCBLIB_iter         : IPCB_LibraryIterator;
    PCBLIB_component    : IPCB_LibComponent;
    Document            : IServerDocument;
    lib_rel_path        : TextFile;
    info                : TStringList;
    i                   : Integer;
    FileDateTime        : String;
    FileTimeStamp       : Integer;
begin
    Document := Client.OpenDocument('PCBLIB', FileName);
    If Document <> Nil Then
    begin
        PCBLIB_sel := PCBServer.GetPCBLibraryByPath(Document.FileName);
        If PCBLIB_sel <> Nil Then
        begin
            PCBLIB_iter := PCBLIB_sel.LibraryIterator_Create;
            PCBLIB_iter.SetState_FilterAll;
            PCBLIB_iter.AddFilter_ObjectSet(MkSet(eComponentObject));
            Try
                PCBLIB_component := PCBLIB_iter.FirstPCBObject;
                While PCBLIB_component <> Nil Do
                Begin
                    lib_rel_path := StringReplace(ExtractRelativePath(lib_path, FileName), '\', '/', MkSet(rfReplaceAll));
                    // Clear info
                    info := TStringList.Create;
                    for i := 0 to getCountParams do
                        info.Add('');
                    // Set Component Description
                    info[isParamExist('NAME')] := PCBLIB_component.Name;
                    info[isParamExist('PATH')] := lib_rel_path;
                    info[isParamExist('TYPE')] := 'PCBLIB';
                    info[isParamExist('DESCRIPTION')] := PCBLIB_component.Description;
                    info[isParamExist('HEIGHT')] := FloatToStr(CoordToMils(PCBLIB_component.Height)) + ' mil';
                    // Last modified date
                    FileTimeStamp := FileAge(FileName);
                    if FileTimeStamp > 0 then
                    begin
                      info[getCountParams] := DateTimeToStr(FileDateToDateTime(FileTimeStamp));
                    end
                    else
                      info[getCountParams] := 'ERR';

                    Add_viewlist(info);
                    PCBLIB_component := PCBLIB_iter.NextPCBObject;
                End;
            Finally
                PCBLIB_sel.LibraryIterator_Destroy(PCBLIB_iter);
            End;
            // ? PCBServer.DestroyPCBLibrary(PCBLIB_sel);
       end;
       Client.CloseDocument(Document);
       PCBServerModule.DestroyDocument(Document);
    end;
end;
{..............................................................................}

{..............................................................................}
// UI: Button_dbgenerateClick
procedure TForm1.Button_dbgenerateClick(Sender: TObject);
var
    // OUTPUT FILE
    dbPath           : String;
    url              : String;

    // SEARCH FILES
    LIB_path         : WideString;
    LIB_files        : TStringList;
    I                : Integer;
    LookInSubFolders : Boolean;
    FileMask         : WideString;
    files_count      : Integer;
    files_max        : Integer;

    // LABELS
    label postprocessing_label;
begin
    // INPUT DIR
    // Note: Don't use space in path
    LIB_path := IncludeTrailingPathDelimiter(Edit_libsearchdir.Text);
    url := Edit_liburl.Text;

    // OUTPUT FILE
    dbPath := Edit_dbsaveto.Text;

    // Cleanup
    SetHeaderViewlist(url);
    files_count := 0;
    files_max := XPSpinEdit_maxfilesno.Value;
    // TODO: altium does not update StatusBar1 as it is busy
    StatusBar1.Panels[0].Text := '';
    Memo1.Clear;

    if FileExists(dbPath) then
    begin
        if MessageDlg('DB file exists. Do you want to overwrite it?', mtConfirmation, MkSet(mbYes, mbNo), 0) = mrNo then
           exit;
    end;

    // Find PCBLIBs
    Try
        LIB_files := TStringList.Create;
        LIB_files.Clear;
        // collect file paths in the LIB_files
        FileMask            := '*.PCBLIB';
        LookInSubFolders    := true;
        FindFiles(LIB_path + '\', FileMask, faAnyFile, LookInSubFolders, LIB_files);
        // If PCBLibs found

        If LIB_files.Count > 0 Then
            For I := 0 to LIB_files.Count - 1 Do
            Begin
                if files_count >= files_max then
                begin
                    MessageDlg('Reached the Max files. Please close the DXP, and continue the rest of files on the next session.', mtWarning, MkSet(mbOK), 0);
                    GOTO postprocessing_label;
                end;
                files_count := files_count + 1;
                Memo1.Clear;
                Memo1.Lines.Add(IntToStr(files_count) + ': ' + LIB_files.Strings[I]);
                ReadPCBLIB(LIB_files.Strings[I], dbPath, LIB_path);
            End;
    Finally
        LIB_files.Free;
    End;

    // Find SCHLIBs
    Try
        LIB_files := TStringList.Create;
        LIB_files.Clear;
        // collect file paths in the LIB_files
        FileMask            := '*.SCHLIB';
        LookInSubFolders    := true;
        FindFiles(LIB_path + '\', FileMask, faAnyFile, LookInSubFolders, LIB_files);

        // If SCHLibs found
        If LIB_files.Count > 0 Then
            For I := 0 to LIB_files.Count - 1 Do
            Begin
                if files_count >= files_max then
                begin
                    MessageDlg('Reached the Max files. Please close the DXP, and continue the rest of files on the next session.', mtWarning, MkSet(mbOK), 0);
                    GOTO postprocessing_label;
                end;
                files_count := files_count + 1;
                Memo1.Clear;
                Memo1.Lines.Add(IntToStr(files_count) + ': ' + LIB_files.Strings[I]);
                ReadSCHLIB(LIB_files.Strings[I], dbPath, LIB_path);
            End;
    Finally
        LIB_files.Free;
    End;

postprocessing_label:
    // Save the output file
    SaveListViewToCSV(ListView1, dbPath);
    // Post processing by python script
    // Due to the limination of Altium Delphi language we need to perfom some processing by python
    DBPostprocessing(dbPath, LIB_path);

    Memo1.Clear;
    Memo1.Lines.Add('Total Lib Files: ' + IntToStr(files_count));

    if FileExists(dbPath) then
    begin
        // Reload the data to listview after postprocessing
        LoadCSVToListView(dbPath);
        Memo1.Lines.Add('DB saved: ' + dbPath);
        StatusBar1.Panels[0].Text := 'DB file has created!';
        ShowMessage('DB file has created!');
    end
    else
        MessageDlg('Failed to generate DB file: ' + dbPath, mtError, MkSet(mbOK), 0);

end;
{..............................................................................}

{..............................................................................}
// UI: Button_findClick
procedure TForm1.Button_findClick(Sender: TObject);
var
  dbPath : String;
  FilterMask : string;

  LineText, ResultText: string;
  FoundPos, i,j: Integer;

  dbColumns : TStringList;
  dbListItem: TListItem;

  // Timestamp
  dbTimestamp : String;
  dbTimestamp_int : Integer;
begin
   dbPath := Edit_dbpath.Text;
   FilterMask := Edit_filter.Text;

   // Check existence of DB
    if not FileExists(dbPath) then
    begin
       MessageDlg('DB file does not exist: ' + dbPath, mtError, MkSet(mbOK), 0);
       exit;
    end;

   // DB timestamp
   dbTimestamp_int := FileAge(dbPath);
   if dbTimestamp_int > 0 then
   begin
     dbTimestamp := DateTimeToStr(FileDateToDateTime(dbTimestamp_int));
   end else
     dbTimestamp := 'ERR';

   // DB loader
   if (length(Info_lastLoadDBPath.Text) = 0)
      or (length(Info_lastLoadDBTimestamp.Text) = 0)
      or (Info_lastLoadDBPath.Text <> dbPath)
      or (Info_lastLoadDBTimestamp.Text = 'ERR')
      or (Info_lastLoadDBTimestamp.Text <> dbTimestamp)
      or (Memo_DB.Lines.Count = 0) then
   begin
      Info_lastLoadDBPath.Text := dbPath;
      Info_lastLoadDBTimestamp.Text := dbTimestamp;
      Memo_DB.Lines.Clear;
      Memo_DB.Lines.LoadFromFile(dbPath);
   end;

   // Clear
   ProgressBar1.Position := 0;
   ProgressBar1.Max := Memo_DB.Lines.Count;
   ListView1.ViewStyle := vsReport;
   ListView1.Columns.Clear;
   ListView1.Items.Clear;
   dbColumns := TStringList.Create;  // Create a TStringList to handle CSV values
   dbColumns.Delimiter := ',';  // Set CSV delimiter (comma)
   dbColumns.StrictDelimiter := True;  // Avoid spaces as delimiters

   // line 0 is header info CSV file
   dbColumns.DelimitedText := Memo_DB.Lines[0];
   for i := 0 to dbColumns.Count - 1 do
   begin
       with ListView1.Columns.Add do
       begin
           Caption := dbColumns[i];
           Width := 100;  // Adjust column width
       end;
   end;

   // Loop through each line in DB file
   // Hint: line 0 is header info
   for i := 1 to Memo_DB.Lines.Count - 1 do
   begin
     LineText := Memo_DB.Lines[i];
     ProgressBar1.Position := i;
     // Application.ProcessMessages; // ?
     // Check if the search text exists in the line
     if (Pos(LowerCase(FilterMask), LowerCase(LineText)) > 0) or (FilterMask = '*') or (Length(FilterMask) = 0) then
     begin

       dbColumns.DelimitedText := LineText;
       if (ComboBox_filter.Text = 'PCBLIB') and (UpperCase(dbColumns[1]) <> 'PCBLIB') then
       begin
          continue;
       end else if (ComboBox_filter.Text = 'SCHLIB') and (UpperCase(dbColumns[1]) <> 'SCHLIB') then
          continue;

       // Add data to listview
       if dbColumns.Count > 0 then
       begin
           dbListItem := ListView1.Items.Add;
           dbListItem.Caption := dbColumns[0];  // First column (main item)

           for j := 1 to dbColumns.Count - 1 do
               dbListItem.SubItems.Add(dbColumns[j]);  // Add subitems

           Application.ProcessMessages;
       end; // dbColumns.Count

     end; // if Pos
   end; // for Memo_DB.Lines.Count
   dbColumns.Free;

end;
{..............................................................................}

{..............................................................................}
// UI: Button_libaddClick
//    - Install/add the selected library to altium library manager
procedure TForm1.Button_libaddClick(Sender: TObject);
Var
    IntMan : IIntegratedLibraryManager;
    libPath : String;
    SelectedItem: TListItem;
Begin
    if ListView1.Selected <> nil then
    begin
        SelectedItem := ListView1.Selected;
        libPath := utl_getLibPathInCache(utl_getListViewItem(SelectedItem, isParamExist('PATH')));

        if not FileExists(libPath) then
        begin
            MessageDlg('File does not exist, please download: ' + libPath, mtError, MkSet(mbOK), 0);
            exit;
        end;

        IntMan := IntegratedLibraryManager;
        If IntMan = Nil Then
        begin
            MessageDlg('Lib Manager failed.', mtError, MkSet(mbOK), 0);
            exit;
        end;
        IntMan.InstallLibrary(libPath);
        MessageDlg('Library installed.', mtInformation, MkSet(mbOK), 0);
    end // if ListView1.Selected <>
    else
        MessageDlg('Select an item.', mtInformation, MkSet(mbOK), 0);
end;
{..............................................................................}

{..............................................................................}
// SelectComponetPartID
//
//   - Hint: if we would be able the Altium PlaceComponent/PartPlace tools, hence,
//   - there is no need for this implementation.
function SelectComponetPartID(component : ISch_Component): Integer;
var
    Form          :      TForm;
    ListBox       :      TListBox;
    OkButton      :      TButton;
    SelectedPart  :      String;
    i             :      Integer;
begin
    // Create the form
    Form := TForm.Create(nil);
    try
        Form.Caption := 'Select a Part';
        Form.Width := 300;
        Form.Height := 200;
        Form.Position := poScreenCenter;

        // Create the list box
        ListBox := TListBox.Create(Form);
        ListBox.Parent := Form;
        ListBox.Align := alTop;
        ListBox.Height := 120;

        // Add items to the list (replace with actual part names)
        for i:= 1 to component.PartCount do
           ListBox.Items.Add('Part: ' + component.PartIdString(i));
        // Default select
        if ListBox.Items.Count > 0 then
            ListBox.ItemIndex := 0;

        // Create the OK button
        OkButton := TButton.Create(Form);
        OkButton.Parent := Form;
        OkButton.Caption := 'OK';
        OkButton.ModalResult := mrOk;
        OkButton.Align := alBottom;

        // Show the form and wait for user selection
        if Form.ShowModal = mrOk then
        begin
            if ListBox.ItemIndex <> -1 then
            begin
                Result := ListBox.ItemIndex + 1;
            end
            else
                ShowMessage('No part was selected.');
        end;
    finally
        Form.Free;
    end;
end;
{..............................................................................}

{..............................................................................}
// UI: Button_placeClick
//   - Place the selected item to schematic/pcb
//   - cache dir. This method automatically download the lib if not available
procedure TForm1.Button_placeClick(Sender: TObject);
var
    SelectedItem            : TListItem;
    cacheDir                : String;
    libPath                 : String;
    libPathUrl              : String;
    libType                 : String;
    libComName              : String;

    Document                : IServerDocument;
    // SCH
    SchDoc                  : ISch_Document;
    SchSel                  : ISch_Lib;
    SchCom                  : ISch_Component;
    // PCB
    PcbBoard                : IPCB_Board;
begin
    cacheDir := utl_prepPathStr(Edit_cacheDir.Text, True);

    if ListView1.Selected <> nil then
    begin
         SelectedItem := ListView1.Selected;
         try
             libPath := utl_getLibPathInCache(utl_getListViewItem(SelectedItem, isParamExist('PATH'))); ;
             libType := UpperCase(utl_getListViewItem(SelectedItem, isParamExist('TYPE')));
             libComName := utl_getListViewItem(SelectedItem, isParamExist('NAME'));
             libPathUrl := utl_getListViewLibURL +  utl_getListViewItem(SelectedItem, isParamExist('PATH'));
         finally
         end;

         // Checkup
         if (libType = 'SCHLIB') or (libType = 'PCBLIB') then
         begin
             // Cache cache
             if not DirectoryExists(cacheDir) then
             begin
                 MessageDlg('Cache dir does not exist.', mtError, MkSet(mbOK), 0);
                 exit;
             end;
             // Auto download
             if not FileExists(libPath) then
             begin
                  if MessageDlg('Do you want to download ' + libComName + '? from ' + libPathUrl, mtConfirmation, MkSet(mbYes, mbNo), 0) = mrYes then
                  begin
                      utl_downloadFunc(libPathUrl, libPath);
                  end
                  else
                      exit;
             end;
         end;


         // SCH component placement
         if (libType = 'SCHLIB') then
         begin
              SchDoc := SchServer.GetCurrentSchDocument;
              if SchDoc = nil then
              begin
                  MessageDlg('Please open a SCH document.', mtInformation, MkSet(mbOK), 0);
                  Exit;
              end;

              Document := Client.OpenDocument('SCHLIB', libPath);
              if Document <> Nil Then
              Begin
                  SchSel := SchServer.GetSchDocumentByPath(Document.FileName);
                  if SchSel <> Nil Then
                  begin
                       schCom := SchSel.GetState_SchComponentByLibRef(libComName);
                       if schCom <> Nil Then
                       Begin
                            // Method 1:
                            // TODO: It used to work at first, but never again
                            // - why this method does not work anymore?
                            // ResetParameters;
                            // AddStringParameter('FileName', libPath);
                            // AddStringParameter('id', libComName);
                            // RunProcess('SCH:PlaceComponent');

                            // Method 2:
                            // schCom.SetState_Orientation := 0;
                            // Select the PartID if applicable
                            if schCom.IsMultiPartComponent then
                                 schCom.CurrentPartID := SelectComponetPartID(schCom);

                            // schCom.SourceLibraryName := name?; // TODO: why source are different than the current libname?
                            SchDoc.AddSchObject(schCom);
                            SchDoc.GraphicallyInvalidate;
                            ResetParameters;
                            RunProcess('Sch:DeSelect');
                            schCom.Selection := True;
                            // Cut and Paste the Selected Part to Attach the part to the Cursor
                            RunProcess ('Sch:Cut');
                            ResetParameters;
                            RunProcess ('Sch:Paste');
                            ResetParameters;

                            // USAGE: Set placement position (modify as needed)
                            // SCHLIB_component.Location := Point(MilsToCoord(500), MilsToCoord(500)); // or := Mouse.CursorPos;
                            // schCom_new.MoveToXY(X, Y);
                            // Add the component to the schematic
                            // SchDoc.RegisterSchObjectInContainer(SCHLIB_component);
                            // Refresh schematic to display the new component
                            //SchDoc.GraphicallyInvalidate;
                            //schCom_new.Selection := True;
                       end // if schCom
                       else MessageDlg('Component does not exist: ' + libComName, mtError, MkSet(mbOK), 0);
                  end // If SchSel
                  else MessageDlg('Failed to open schlib: ' + libPath , mtError, MkSet(mbOK), 0);
                  // Close document before leave
                  Client.CloseDocument(Document);
              end // if Document
              else MessageDlg('Lib does not exist: ' + libPath, mtError, MkSet(mbOK), 0);
         end // if SCHLIB

         // PCB component placement
         else if (libType = 'PCBLIB') then
         begin
              PcbBoard := PcbServer.GetCurrentPCBBoard;
              if PcbBoard = nil then
              begin
                  MessageDlg('Please open a PCB document.', mtInformation, MkSet(mbOK), 0);
                  Exit;
              end;

              // TODO: Check is doc is present?
              // Investigate: Is it possible to use PcbServer.PCBObjectFactory instead?
              ResetParameters;
              AddStringParameter('FileName', libPath);
              AddStringParameter('Footprint', libComName);
              RunProcess('PCB:PlaceComponent');

              // USAGE: insert a componet from .Intlib
              //If IntegratedLibraryManager = Nil Then Exit;
              //IntegratedLibraryManager.PlaceLibraryComponent(
              //    'Res2',
              //    'Miscellaneous Devices.IntLib',
              //    'Location.X=5000000|Location.Y=5000000');
              //
              // or using runprocess
              // ResetParameters;
              // RunProcess('IntegratedLibrary:PlaceLibraryComponent');

              // USAGE: Open a libpcb component as its primitive
              // Document := Client.OpenDocument('PCBLIB', libraryPath);
              // PcbSel := PCBServer.GetPCBLibraryByPath(Document.FileName);
              // PcbCom := PcbSel.GetComponentByName(Edit4.Text);
              // PcbBoard.AddPCBObject(PcbCom);
              // PCBServer.PostProcess;

              // USAGE: Select a componet with mouse
              // PcbBoard.ChooseLocation(x,y, 'Choose Component1');
              // LibComponent := PcbBoard.GetObjectAtXYAskUserIfAmbiguous(x,y,MkSet(eComponentObject),AllLayers, eEditAction_Select);
              // If Not Assigned(LibComponent) Then Exit;

              // USAGE: To open library component
              // AddStringParameter('Footprint', footprintName);
              // AddStringParameter('FileName', libraryPath);
              // RunProcess('PCB:GotoLibraryComponent');
         end // if PCBLIB
         else // TYPE <> PCBLIB or SCHLIB
              MessageDlg('DB file is broken, please fecth a new one.', mtError, MkSet(mbOK), 0);
    end // if ListView1.Selected <> nil
    else
         MessageDlg('Select an item.', mtInformation, MkSet(mbOK), 0);
end;
{..............................................................................}

{..............................................................................}
// UI: Button_aboutClick
procedure TForm1.Button_aboutClick(Sender: TObject);
begin
    MessageDlg('Maintained by: Shahim Vedaei <shahim.vedaei@gmail.com>', mtInformation, MkSet(mbOK), 0);
end;

{................................................................................................................}

