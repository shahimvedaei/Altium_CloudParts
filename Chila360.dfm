object Form1: TForm1
  Left = 0
  Top = 0
  Width = 725
  Height = 789
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
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 1017
    Width = 686
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitWidth = 685
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 0
    Width = 664
    Height = 560
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
      Left = 152
      Top = 528
      Width = 136
      Height = 25
      Caption = 'Add Lib to project'
      TabOrder = 0
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
      TabOrder = 3
      OnClick = Button_dbfetchClick
    end
    object Button_dbload: TButton
      Left = 384
      Top = 24
      Width = 59
      Height = 25
      Caption = 'Load DB'
      TabOrder = 4
      OnClick = Button_dbloadClick
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
      TabOrder = 5
    end
    object Edit_filter: TEdit
      Left = 136
      Top = 24
      Width = 244
      Height = 24
      TabOrder = 6
      Text = '*'
    end
    object Button_libdownload: TButton
      Left = 16
      Top = 528
      Width = 124
      Height = 25
      Caption = 'Download'
      TabOrder = 7
      OnClick = Button_libdownloadClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 576
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
      Width = 85
      Height = 18
      Caption = 'Download to:'
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
    object Edit_dburl: TEdit
      Left = 72
      Top = 32
      Width = 572
      Height = 24
      TabOrder = 0
      Text = 
        'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main' +
        '/DB.csv'
    end
    object Edit_libdownloadto: TXPDirectoryEdit
      Left = 104
      Top = 96
      Width = 540
      Height = 24
      StretchButtonImage = False
      TabOrder = 1
      Text = 'C:\Users\Shahi\Desktop\TEST_AD_LIB\'
    end
    object Edit_dbpath: TXPFileNameEdit
      Left = 72
      Top = 64
      Width = 572
      Height = 24
      FilterIndex = 0
      StretchButtonImage = False
      TabOrder = 2
      Text = 'C:\Users\Shahi\Desktop\TEST_AD_LIB\DB.csv'
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 717
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
    object Edit_liburl: TEdit
      Left = 84
      Top = 88
      Width = 560
      Height = 24
      TabOrder = 0
      Text = 
        'https://github.com/chilaboard/Altium-Library/raw/refs/heads/main' +
        '/'
    end
    object Edit_dbsaveto: TXPFileNameEdit
      Left = 84
      Top = 56
      Width = 560
      Height = 24
      FilterIndex = 0
      StretchButtonImage = False
      TabOrder = 1
      Text = 'C:\Users\Shahi\Desktop\TEST_AD_LIB\DB.csv'
    end
    object Edit_libsearchdir: TXPDirectoryEdit
      Left = 88
      Top = 24
      Width = 412
      Height = 24
      StretchButtonImage = False
      TabOrder = 2
      Text = 'C:\Users\Shahi\Downloads\Altium-Library-main\Altium-Library-main'
    end
    object Button_dbgenerate: TButton
      Left = 508
      Top = 121
      Width = 136
      Height = 32
      Caption = 'DB Generate'
      TabOrder = 3
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
  end
  object Memo1: TMemo
    Left = 12
    Top = 890
    Width = 664
    Height = 127
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Consule')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 104
    object NFile1: TMenuItem
      Caption = 'File'
      object NSettings1: TMenuItem
        Caption = 'Settings'
      end
      object NExit1: TMenuItem
        Caption = 'Exit'
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
