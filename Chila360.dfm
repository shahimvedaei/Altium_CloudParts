object Form1: TForm1
  Left = 0
  Top = 0
  Width = 725
  Height = 789
  HorzScrollBar.Visible = False
  AutoScroll = True
  Caption = 'Chila360 Online Lib Search'
  Color = clGrayText
  Constraints.MaxWidth = 725
  Constraints.MinWidth = 725
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnShow = Form_loadSettings
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 1033
    Width = 1022
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 0
    Width = 664
    Height = 583
    Caption = 'Search'
    TabOrder = 1
    object Label1: TLabel
      Left = 520
      Top = 24
      Width = 35
      Height = 18
      Caption = 'Filter:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button_libadd: TButton
      Left = 564
      Top = 544
      Width = 84
      Height = 25
      Caption = 'Add Lib'
      TabOrder = 5
      OnClick = Button_libaddClick
    end
    object Button_find: TButton
      Left = 9
      Top = 24
      Width = 119
      Height = 25
      Caption = 'Find'
      TabOrder = 1
      OnClick = Button_findClick
    end
    object ComboBox_filter: TComboBox
      Left = 567
      Top = 24
      Width = 89
      Height = 24
      ItemIndex = 0
      TabOrder = 2
      Text = 'All'
      Items.Strings = (
        'All'
        'PCBLIB'
        'SCHLIB')
    end
    object Button_dbfetch: TButton
      Left = 448
      Top = 24
      Width = 64
      Height = 25
      Caption = 'Fetch DB'
      TabOrder = 6
      OnClick = Button_dbfetchClick
    end
    object ListView1: TListView
      Left = 16
      Top = 64
      Width = 632
      Height = 456
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
      TabOrder = 7
    end
    object Edit_filter: TEdit
      Left = 136
      Top = 24
      Width = 244
      Height = 24
      TabOrder = 0
      Text = '*'
    end
    object Button_libdownload: TButton
      Left = 452
      Top = 544
      Width = 104
      Height = 25
      Caption = 'Download'
      TabOrder = 4
      OnClick = Button_libdownloadClick
    end
    object Button_place: TButton
      Left = 16
      Top = 544
      Width = 188
      Height = 25
      Caption = 'Place'
      TabOrder = 3
      OnClick = Button_placeClick
    end
    object ProgressBar1: TProgressBar
      Left = 20
      Top = 528
      Width = 624
      Height = 7
      Step = 1
      TabOrder = 8
    end
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 592
    Width = 664
    Height = 132
    Caption = 'Settings'
    Color = clGrayText
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 96
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
      Left = 8
      Top = 32
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
      Left = 8
      Top = 64
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
    object Edit_cacheDir: TXPDirectoryEdit
      Left = 104
      Top = 94
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
      Left = 72
      Top = 62
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
      Left = 72
      Top = 30
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
      Text = 
        'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main' +
        '/DB.csv'
      OnExit = Form_saveSettings
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 733
    Width = 664
    Height = 161
    Caption = 'DB Generator'
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
      Height = 141
      ExplicitLeft = 104
      ExplicitTop = 136
      ExplicitHeight = 100
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
      Left = 508
      Top = 121
      Width = 136
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
      Left = 8
      Top = 128
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
  end
  object Memo_log: TMemo
    Left = 12
    Top = 906
    Width = 664
    Height = 127
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
    TabOrder = 4
  end
  object GroupBox4: TGroupBox
    Left = 696
    Top = 8
    Width = 326
    Height = 568
    Caption = 'Background process'
    TabOrder = 5
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
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 104
    object NFile1: TMenuItem
      Caption = 'File'
      object NExit1: TMenuItem
        Caption = 'Exit'
        OnClick = NExit1Click
      end
    end
    object NAbout1: TMenuItem
      Caption = 'Help'
      object Button_about: TMenuItem
        Caption = 'About'
        OnClick = Button_aboutClick
      end
    end
  end
end
