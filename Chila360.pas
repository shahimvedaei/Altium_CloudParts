{................................................................................................................
    Chila360.ps
    Description:
        Altium Designer DelphiScript to generate a database of all components in the libraries with access to Git.

    License:    MIT
    Copywrite:  FEB 2025
    Version:    2.0
    Maintainer: Shahim Vedaei <shahim.vedaei@gmail.com>

    Refs:
    [1] https://www.altium.com/documentation/altium-dxp-developer/

    TODO:
    ----------------------------------------------------------------------------------------------------------
    PRI  |  Description
    ----------------------------------------------------------------------------------------------------------
    2    |   Cleancoding
    2    |   Check the output of RunApplicationAndWAit
    4    |   Investigate DLL usage

................................................................................................................}


{..............................................................................}
// RunPythonScript
//     Run a Python script and get the output
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
// download_url
//     Download a file from a URL
//     url: string, the URL to download
//     saveto: string, the path to save the downloaded file
procedure download_url(const url: string; const saveto: string);
var
    args : String;
    res : String;
begin
    args := '--action=download_url --url=' + url + ' --saveto=' + saveto;
    RunPythonScript(args, res);
end;
{..............................................................................}

{..............................................................................}
// DBPostprocessing
//     Post processing the DB file. Altium script has a limitation to perform some tasks.
//     So, we need to use Python to do some tasks.
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
begin
    StatusBar1.Panels[0].Text := 'Fetching DB ...';
    download_url(Edit_dburl.Text, Edit_dbpath.Text);
    StatusBar1.Panels[0].Text := 'Fetch DB completed.';
end;
{..............................................................................}

{..............................................................................}
procedure SetHeaderViewlist(const url: string);
begin
    // Add columns
    // Set ListView to Report mode
    ListView1.ViewStyle := vsReport;
    // Ensure Full Columns are visible
    ListView1.Columns.Clear; // Clear any existing columns
    ListView1.Items.Clear;  
    with ListView1.Columns.Add do
    begin
      Caption := 'Name';
      Width := 100; // Adjust width
    end;
    with ListView1.Columns.Add do
    begin
      Caption := 'Type';
      Width := 100;
    end; 
    with ListView1.Columns.Add do
    begin
      Caption := url;
      Width := 400;
    end;
end;
{..............................................................................}

{..............................................................................}
procedure Add_viewlist(const a: string; const b: string; const c: string);
var
    Item: TListItem;
begin
    // Add first row
    Item := ListView1.Items.Add;
    Item.Caption := a;
    Item.SubItems.Add(b);
    Item.SubItems.Add(c);

    // TODO: do we really need to?
    //ListView1.Invalidate;  // Force refresh
    //ListView1.Repaint;
    Application.ProcessMessages;
end;
{..............................................................................}

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
            Line := Line + ListView.Columns[i].Caption;
            if i < ListView.Columns.Count - 1 then
                Line := Line + ',';
            end;
            Writeln(CSVFile, Line);

            // Write ListView items
            for i := 0 to ListView.Items.Count - 1 do
            begin
                Line := ListView.Items[i].Caption; // First column

                // Add subitems
                for j := 0 to ListView.Items[i].SubItems.Count - 1 do
                    Line := Line + ',' + ListView.Items[i].SubItems[j];

                Writeln(CSVFile, Line);
            end;

    finally
        CloseFile(CSVFile);
    end;
end;
{..............................................................................}

{..............................................................................}
procedure LoadCSVToListView(const FileName: string);
var
    CSVFile: TextFile;
    Line: string;
    Columns: TStringList;
    i: Integer;
    ListItem: TListItem;
    FilterMask : String;
begin
    // Ensure ListView is in Report mode
    ListView1.ViewStyle := vsReport;
    ListView1.Columns.Clear;
    ListView1.Items.Clear;
    // Create a TStringList to handle CSV values
    Columns := TStringList.Create;

    FilterMask := Edit_filter.Text;

    try
        Columns.Delimiter := ',';  // Set CSV delimiter (comma)
        Columns.StrictDelimiter := True;  // Avoid spaces as delimiters

        // Open the CSV file
        AssignFile(CSVFile, FileName);
        Reset(CSVFile);

        // Read the first line (Header) and create columns
        if not Eof(CSVFile) then
        begin
            ReadLn(CSVFile, Line);
            Columns.DelimitedText := Line;  // Split header

            for i := 0 to Columns.Count - 1 do
            begin
                with ListView1.Columns.Add do
                begin
                    Caption := Columns[i];
                    Width := 100;  // Adjust column width
                end;
            end;
        end;

        // Read the rest of the CSV data
        while not Eof(CSVFile) do
        begin
            ReadLn(CSVFile, Line);
            Columns.DelimitedText := Line;

            if Columns.Count > 0 then
            begin
                if ((ComboBox_filter.Text = 'PCBLIB') and (UpperCase(Columns[1]) <> 'PCBLIB')) or
                   ((ComboBox_filter.Text = 'SCHLIB') and (UpperCase(Columns[1]) <> 'SCHLIB')) then
                    Continue;

                if (FilterMask = '*') or (Pos(LowerCase(FilterMask), LowerCase(Columns[0])) > 0) then
                begin
                    ListItem := ListView1.Items.Add;
                    ListItem.Caption := Columns[0];  // First column (main item)

                    for i := 1 to Columns.Count - 1 do
                        ListItem.SubItems.Add(Columns[i]);  // Add subitems

                    Application.ProcessMessages;
                end;
            end;
        end;

    // Close file
    CloseFile(CSVFile);

    finally
      Columns.Free;
    end;
end;
{..............................................................................}

{..............................................................................}
// UI: Button_dbloadClick
procedure TForm1.Button_dbloadClick(Sender: TObject);
begin
    LoadCSVToListView(Edit_dbsaveto.Text);
end;
{..............................................................................}

{..............................................................................}
// UI: Button_libdownloadClick
procedure TForm1.Button_libdownloadClick(Sender: TObject);
var
SelectedItem: TListItem;
SelectedData: string;
begin
    if ListView1.Selected <> nil then
    begin
        SelectedItem := ListView1.Selected;
        SelectedData := ListView1.Columns[2].Caption + SelectedItem.SubItems[1];
        StatusBar1.Panels[0].Text := 'Downloading...';
        download_url(SelectedData, Edit_libdownloadto.Text);
        StatusBar1.Panels[0].Text := 'Download completed.';
        ShowMessage('Download completed.');
        Memo1.Lines.Add('Download: ' + SelectedData + ', to ' + Edit_libdownloadto.Text + ' complited');
    end;
end;
{..............................................................................}

{..............................................................................}
procedure ReadSCHLIB(const FileName: string; db_path: string; lib_path: string);
var
    SCHLIB_sel                  : ISch_Lib;
    SCHLIB_iter                 : ISCH_Iterator;
    SCHLIB_component            : ISch_Component;
    Document                    : IServerDocument;
    lib_rel_path        : TextFile;
begin

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
                    Add_viewlist(SCHLIB_component.LibReference, 'SCHLIB', lib_rel_path);
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
                    Add_viewlist(PCBLIB_component.Name, 'PCBLIB' , lib_rel_path);
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
    db_path          : String;
    url              : String;

    // SEARCH FILES
    LIB_path         : WideString;
    LIB_files        : TStringList;
    I                : Integer;
    LookInSubFolders : Boolean;
    FileMask         : WideString;
    files_count       : Integer;
    files_max         : Integer;

    // LABELS
    label postprocessing_label;
begin
    // INPUT DIR
    // Note: Don't use space in path
    LIB_path := IncludeTrailingPathDelimiter(Edit_libsearchdir.Text);
    url := Edit_liburl.Text;

    // OUTPUT FILE
    db_path := Edit_dbsaveto.Text;

    // Cleanup
    SetHeaderViewlist(url);
    files_count := 0;
    files_max := XPSpinEdit_maxfilesno.Value;
    // TODO: altium does not update StatusBar1 as it is busy
    StatusBar1.Panels[0].Text := '';
    Memo1.Clear;

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
                    ShowMessage('Reached the Max files. Please close the DXP, and continue the rest of files on the next session.');
                    GOTO postprocessing_label;
                end;
                files_count := files_count + 1;
                Memo1.Clear;
                Memo1.Lines.Add(IntToStr(files_count) + ': ' + LIB_files.Strings[I]);
                ReadPCBLIB(LIB_files.Strings[I], db_path, LIB_path);
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
                    ShowMessage('Reached the Max files. Please close the DXP, and continue the rest of files on the next session.');
                    GOTO postprocessing_label;
                end;
                files_count := files_count + 1;
                Memo1.Clear;
                Memo1.Lines.Add(IntToStr(files_count) + ': ' + LIB_files.Strings[I]);
                ReadSCHLIB(LIB_files.Strings[I], db_path, LIB_path);
            End;
    Finally
        LIB_files.Free;
    End;

postprocessing_label:
    // Save the output file
    SaveListViewToCSV(ListView1, db_path);
    // Post processing by python script
    // Due to the limination of Altium Delphi language we need to perfom some processing by python
    DBPostprocessing(db_path, LIB_path);

    Memo1.Clear;
    Memo1.Lines.Add('Total Lib Files: ' + IntToStr(files_count));
    Memo1.Lines.Add('DB saved: ' + db_path);
    StatusBar1.Panels[0].Text := 'DB file has created!';
    ShowMessage('DB file has created!');
end;
{..............................................................................}

{..............................................................................}
// UI: Button_findClick
procedure TForm1.Button_findClick(Sender: TObject);
begin
    LoadCSVToListView(Edit_dbsaveto.Text);
end;
{..............................................................................}

{..............................................................................}
// UI: Button_libaddClick
procedure TForm1.Button_libaddClick(Sender: TObject);
Var
    IntMan : IIntegratedLibraryManager;
    LibFileName : String;
    SelectedItem: TListItem;
Begin
    if ListView1.Selected <> nil then
    begin
        SelectedItem := ListView1.Selected;
        LibFileName := Edit_libdownloadto.Text + ExtractUrlFilename(ListView1.Columns[2].Caption + SelectedItem.SubItems[1]);
        IntMan := IntegratedLibraryManager;
        If IntMan = Nil Then
        begin
            ShowMessage('error');
            Exit;
        end;
        IntMan.InstallLibrary(LibFileName);
        ShowMessage('lib added');
    end;
end;
{..............................................................................}

{..............................................................................}
// UI: Button_aboutClick
procedure TForm1.Button_aboutClick(Sender: TObject);
begin
    ShowMessage('Maintained by: Shahim Vedaei <shahim.vedaei@gmail.com>');
end;


{................................................................................................................}

