object Form1: TForm1
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  Caption = 'CloudParts, Search and Place Components from Cloud'
  ClientHeight = 648
  ClientWidth = 682
  Color = 2763306
  Constraints.MaxHeight = 695
  Constraints.MaxWidth = 700
  Constraints.MinHeight = 695
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = Form_loadSettings
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 629
    Width = 682
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox_components: TGroupBox
    Left = 12
    Top = 8
    Width = 664
    Height = 576
    Caption = 'Components'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object XPSplitter2: TXPSplitter
      Left = 2
      Top = 18
      Height = 556
      ExplicitLeft = 328
      ExplicitTop = 504
      ExplicitHeight = 100
    end
    object ComboBox_filter: TComboBox
      Left = 343
      Top = 24
      Width = 69
      Height = 24
      ItemIndex = 0
      TabOrder = 1
      Text = 'All'
      Items.Strings = (
        'All'
        'PCBLIB'
        'SCHLIB')
    end
    object ListView1: TListView
      Left = 16
      Top = 64
      Width = 632
      Height = 440
      Color = clMenu
      Columns = <
        item
        end>
      GridLines = True
      Groups = <
        item
          Header = 'Components'
          GroupID = 0
          State = [lgsNormal]
          HeaderAlign = taLeftJustify
          FooterAlign = taLeftJustify
          TitleImage = -1
        end>
      ReadOnly = True
      RowSelect = True
      ShowWorkAreas = True
      TabOrder = 2
    end
    object Edit_filter: TEdit
      Left = 16
      Top = 24
      Width = 316
      Height = 24
      TabOrder = 0
      Text = '*'
    end
    object ProgressBar1: TProgressBar
      Left = 20
      Top = 512
      Width = 624
      Height = 7
      Step = 1
      TabOrder = 3
    end
    object Button_libdownload: TXPButton
      Left = 452
      Top = 528
      Width = 100
      Height = 32
      Caption = 'DOWNLOAD'
      Color = 7646658
      ParentColor = False
      TabOrder = 4
      TabStop = False
      OnClick = Button_libdownloadClick
    end
    object Button_libadd: TXPButton
      Left = 564
      Top = 528
      Width = 85
      Height = 32
      Caption = 'ADD LIB'
      Color = 7646658
      ParentColor = False
      TabOrder = 5
      TabStop = False
      OnClick = Button_libaddClick
    end
    object Button_find: TXPButton
      Left = 508
      Top = 23
      Width = 140
      Height = 32
      Caption = 'SEARCH'
      Color = 7646658
      ParentColor = False
      TabOrder = 6
      TabStop = False
      OnClick = Button_findClick
    end
    object Button_place: TXPButton
      Left = 16
      Top = 528
      Width = 228
      Height = 32
      Caption = 'PLACE'
      Color = 7646658
      ParentColor = False
      TabOrder = 7
      TabStop = False
      OnClick = Button_placeClick
    end
  end
  object GroupBox_settings: TGroupBox
    Left = 692
    Top = 16
    Width = 664
    Height = 416
    Caption = 'Settings'
    Color = 7646658
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    object Label4: TLabel
      Left = 16
      Top = 296
      Width = 86
      Height = 18
      Caption = 'Cache folder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 55
      Height = 18
      Caption = 'DB URL:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 16
      Top = 264
      Width = 58
      Height = 18
      Caption = 'DB path:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 20
      Top = 332
      Width = 132
      Height = 18
      Caption = 'Install Library folder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit_cacheDir: TXPDirectoryEdit
      Left = 112
      Top = 294
      Width = 540
      Height = 24
      Color = clWindowFrame
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      StretchButtonImage = False
      TabOrder = 2
      Text = 'C:\'
      OnExit = Form_saveSettings
    end
    object Edit_dbpath: TXPFileNameEdit
      Left = 80
      Top = 262
      Width = 572
      Height = 24
      Color = clGrayText
      FilterIndex = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      StretchButtonImage = False
      TabOrder = 1
      Text = 'C:\DB.csv'
      OnExit = Form_saveSettings
    end
    object Edit_dburl: TXPEdit
      Left = 80
      Top = 54
      Width = 564
      Height = 24
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = ''
      OnExit = Form_saveSettings
    end
    object Button_dbfetch: TButton
      Left = 399
      Top = 24
      Width = 116
      Height = 25
      Caption = 'Download DB'
      TabOrder = 3
      OnClick = Button_dbfetchClick
    end
    object Edit_libInstallPath: TXPDirectoryEdit
      Left = 164
      Top = 328
      Width = 488
      Height = 24
      StretchButtonImage = False
      TabOrder = 4
      Text = 'C:\'
    end
    object Button_dbListServerUpdate: TXPButton
      Left = 534
      Top = 24
      Width = 108
      Height = 24
      Caption = 'Update DB list'
      ParentColor = False
      TabOrder = 5
      TabStop = False
      OnClick = Button_dbListServerUpdateClick
    end
    object ListView_dbListServer: TListView
      Left = 16
      Top = 88
      Width = 628
      Height = 150
      Columns = <>
      TabOrder = 6
      OnChange = ListView_dbListServerChange
    end
  end
  object GroupBox_DBGenerator: TGroupBox
    Left = 692
    Top = 448
    Width = 664
    Height = 560
    Caption = 'DB Generator'
    Color = 7646658
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 71
      Height = 18
      Caption = 'Search Dir:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 56
      Width = 55
      Height = 18
      Caption = 'Save to:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 58
      Height = 18
      Caption = 'LIB URL:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 520
      Top = 24
      Width = 62
      Height = 18
      Caption = 'Max files:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object XPSplitter1: TXPSplitter
      Left = 2
      Top = 18
      Height = 540
      ExplicitLeft = 104
      ExplicitTop = 136
      ExplicitHeight = 100
    end
    object Label18: TLabel
      Left = 9
      Top = 124
      Width = 54
      Height = 18
      Caption = 'Params:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit_dbsaveto: TXPFileNameEdit
      Left = 88
      Top = 54
      Width = 556
      Height = 24
      FilterIndex = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
      ParentFont = False
      StretchButtonImage = False
      TabOrder = 1
      Text = 'C:\DB.csv'
      OnExit = Form_saveSettings
    end
    object Edit_libsearchdir: TXPDirectoryEdit
      Left = 88
      Top = 22
      Width = 412
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      StretchButtonImage = False
      TabOrder = 0
      Text = 'C:\Users\Shahi\Downloads\Altium-Library-main\Altium-Library-main'
      OnExit = Form_saveSettings
    end
    object Button_dbgenerate: TButton
      Left = 484
      Top = 361
      Width = 160
      Height = 32
      Caption = 'DB Generate'
      TabOrder = 5
      OnClick = Button_dbgenerateClick
    end
    object XPSpinEdit_maxfilesno: TXPSpinEdit
      Left = 588
      Top = 24
      Width = 56
      Height = 24
      TabOrder = 4
      Value = 500
    end
    object CheckBox_updateDB: TCheckBox
      Left = 15
      Top = 372
      Width = 156
      Height = 18
      Caption = 'Update existing DB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Edit_liburl: TXPEdit
      Left = 88
      Top = 86
      Width = 556
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 
        'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main' +
        '/'
      OnExit = Form_saveSettings
    end
    object Memo_log: TMemo
      Left = 10
      Top = 408
      Width = 640
      Height = 131
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'Log')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 6
    end
    object Edit_dbParams: TXPEdit
      Left = 88
      Top = 121
      Width = 508
      Height = 24
      TabOrder = 7
      Text = ''
    end
    object ListBox_dbParams: TListBox
      Left = 88
      Top = 152
      Width = 508
      Height = 176
      TabOrder = 8
    end
    object Button_dbParamsAdd: TButton
      Left = 608
      Top = 120
      Width = 28
      Height = 25
      Caption = '+'
      TabOrder = 9
      OnClick = Button_dbParamsAddClick
      OnExit = Form_saveSettings
    end
    object Button_dbParamsDelete: TButton
      Left = 608
      Top = 152
      Width = 28
      Height = 25
      Caption = '-'
      TabOrder = 10
      OnClick = Button_dbParamsDeleteClick
      OnExit = Form_saveSettings
    end
  end
  object GroupBox4: TGroupBox
    Left = 1376
    Top = 168
    Width = 326
    Height = 480
    Caption = 'Background process'
    TabOrder = 4
    object Label9: TLabel
      Left = 8
      Top = 32
      Width = 272
      Height = 16
      Caption = 'For tool background, usage and shall not visible'
    end
    object Label10: TLabel
      Left = 8
      Top = 288
      Width = 193
      Height = 16
      Caption = 'Setting ini file info for comparison'
    end
    object Label11: TLabel
      Left = 8
      Top = 160
      Width = 163
      Height = 16
      Caption = 'DB file content for quick load'
    end
    object Label12: TLabel
      Left = 8
      Top = 104
      Width = 142
      Height = 16
      Caption = 'DB file last modified time'
    end
    object Label13: TLabel
      Left = 8
      Top = 56
      Width = 124
      Height = 16
      Caption = 'Load load DB file path'
    end
    object Label19: TLabel
      Left = 8
      Top = 416
      Width = 185
      Height = 16
      Caption = 'Multi purpose temporary memo:'
    end
    object Memo_DB: TMemo
      Left = 8
      Top = 183
      Width = 312
      Height = 89
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object Info_lastLoadDBTimestamp: TEdit
      Left = 8
      Top = 128
      Width = 312
      Height = 24
      TabOrder = 1
    end
    object Info_lastLoadDBPath: TEdit
      Left = 8
      Top = 72
      Width = 312
      Height = 24
      TabOrder = 2
    end
    object Memo_settings: TMemo
      Left = 8
      Top = 312
      Width = 312
      Height = 89
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
      WordWrap = False
    end
    object Memo_tempBuffer: TMemo
      Left = 8
      Top = 432
      Width = 312
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 4
      WordWrap = False
    end
  end
  object XPButtonEx1: TXPButtonEx
    Left = 376
    Top = 648
    Width = 0
    Height = 0
    BitmapIndex = 0
    DownBitmapIndex = 0
    Caption = 'XPButtonEx1'
    ParentColor = False
    TabOrder = 5
    TabStop = False
  end
  object Button_selComponentsPage: TXPButton
    Left = 16
    Top = 592
    Width = 150
    Height = 26
    Caption = 'Components'
    Color = 7646658
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    TabStop = False
    OnClick = Button_selComponentsPageClick
  end
  object Button_selSettingsPage: TXPButton
    Left = 187
    Top = 592
    Width = 150
    Height = 26
    Caption = 'Settings'
    Color = 7646658
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 7
    TabStop = False
    OnClick = Button_selSettingsPageClick
  end
  object Button_selDBGeneratorPage: TXPButton
    Left = 355
    Top = 592
    Width = 150
    Height = 26
    Caption = 'DataBase Gen'
    Color = 7646658
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 8
    TabStop = False
    OnClick = Button_selDBGeneratorPageClick
  end
  object Button_selInfoPage: TXPButton
    Left = 525
    Top = 592
    Width = 150
    Height = 26
    Caption = 'Info'
    Color = 7646658
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 9
    TabStop = False
    OnClick = Button_selInfoPageClick
  end
  object GroupBox_info: TGroupBox
    Left = 1364
    Top = 16
    Width = 664
    Height = 144
    Caption = 'Info'
    Color = 7646658
    ParentBackground = False
    ParentColor = False
    TabOrder = 10
    object Label1: TLabel
      Left = 48
      Top = 40
      Width = 352
      Height = 18
      Caption = 'CloudParts, Search and Place Components from Cloud'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 48
      Top = 88
      Width = 171
      Height = 18
      Caption = 'Maintainer: Shahim Vedaei'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 48
      Top = 112
      Width = 218
      Height = 18
      Caption = 'Email: Shahim.Vedaei@gmail.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 48
      Top = 64
      Width = 78
      Height = 18
      Caption = 'Version: 2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
end
