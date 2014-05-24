unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.MPlayer,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.ImgList, Vcl.Menus, Vcl.Imaging.pngimage,
  Vcl.ToolWin;

const
  program_name = 'Digital Piano';
  nNotes = 84;
  nPlayers = 8;
  wkey_width = 64;    //72
  bkey_width = 36;     //41
  wkey_height = 325;   //371
  bkey_height = 216;   //247
  bspace = 18;                       //blank space
  fwhite = 'img\white.bmp';
  fwhite_p = 'img\white_pressed.bmp';
  fblack = 'img\black.bmp';
  fblack_p = 'img\black_pressed.bmp';
  fRightArrow = 'img\arrowRightButtonOP.png';
  fRightArrow_p = 'img\arrowRightButtonHIT.png';
  fLeftArrow = 'img\arrowLeftButtonOP.png';
  fLeftArrow_p = 'img\arrowLeftButtonHIT.png';
  keybinds1 = '1Q2W3E4R5T6Y7U8I9O0P-[=]\';
  keybinds2 = 'AZSXDCFVGBHNJMK<L>:?"';

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    Panel1: TPanel;
    MediaPlayer2: TMediaPlayer;
    MediaPlayer3: TMediaPlayer;
    MediaPlayer4: TMediaPlayer;
    MediaPlayer5: TMediaPlayer;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    About1: TMenuItem;
    N1Keyboard: TMenuItem;
    N2Keyboards: TMenuItem;
    N1: TMenuItem;
    NnoteNames: TMenuItem;
    Nkeybinds: TMenuItem;
    Exit1: TMenuItem;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    MediaPlayer6: TMediaPlayer;
    MediaPlayer7: TMediaPlayer;
    MediaPlayer8: TMediaPlayer;
    Image3: TImage;
    Image4: TImage;
    Instrument1: TMenuItem;
    NAcoustic: TMenuItem;
    NElectric: TMenuItem;
    NRhodes: TMenuItem;
    NOrgan: TMenuItem;
    NHarps: TMenuItem;
    NSynth: TMenuItem;
    PanelEditor: TPanel;
    NoteLines: TImage;
    Image6: TImage;
    Edit2: TMenuItem;
    NEditor: TMenuItem;
    NRecord: TMenuItem;
    NPlay: TMenuItem;
    NOpen: TMenuItem;
    NSave: TMenuItem;
    N2: TMenuItem;
    Stop1: TMenuItem;
    Timer2: TTimer;
    Timer3: TTimer;
    NLong: TMenuItem;
    Panel3: TScrollBox;
    Line1: TShape;
    MysticNote: TImage;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Clear1: TMenuItem;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TurnMpOff(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure N1KeyboardClick(Sender: TObject);
    procedure N2KeyboardsClick(Sender: TObject);
    procedure NnoteNamesClick(Sender: TObject);
    procedure NkeybindsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NAcousticClick(Sender: TObject);
    procedure NElectricClick(Sender: TObject);
    procedure NHarpsClick(Sender: TObject);
    procedure NOrganClick(Sender: TObject);
    procedure NRhodesClick(Sender: TObject);
    procedure NSynthClick(Sender: TObject);
    procedure PanelMouseEnter(Sender: TObject);
    procedure PanelMouseLeave(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure NEditorClick(Sender: TObject);
    procedure NRecordClick(Sender: TObject);
    procedure NPlayClick(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure NLongClick(Sender: TObject);
    procedure NSaveClick(Sender: TObject);
    procedure NOpenClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TKey_Color = (black, white);                                //колір клавіші фортепіано - білий чи чорний
  TKey_Name = (C, C_, D, D_, E, F, F_, G, G_, A, A_, B);      //назва ноти (до, до#, ре, ре#, мі, фа, фа#, соль, соль#, ля, ля#, сі)

  MIDI_Note = record
    note: byte;
    Tstart: single;
    Tend: single;
    length: single;
    image: TImage;
    sign: TImage;
  end;

  TPiano_Note = class(TObject)
    constructor Create(note_name: TKey_Name; oct: byte);
  private
    fsound: string;
    numMP: byte;
  public
    pressed: boolean;                    // показує, чи натиснута зараз нота
    color: TKey_Color;
    name: TKey_Name;                     // тип ноти - для використання в коді програми
    strName: string;                     // назва ноти - як стрічка, для виведення підписів на клавішах
    procedure PlayNote;
    procedure Stop;
  end;

  TPiano_Key = class(TObject)
    constructor Create(i: byte; pParent: TPanel);
  private
    imgKey: TImage;
    Keybind: TLabel;
    Key_name: TLabel;
  public
    pNote: ^TPiano_Note;
    procedure KeyDown;
    procedure KeyUp;
    procedure Show;
  end;

  TPiano = class(TObject)                // клас - частина фортепіано, яка відображається екрані
  private
    Keys: array of TPiano_Key;                // клавіші
    first_note: byte;                                // номер першої ноти, яка виведена на екран
  public
    procedure ShowKeys(const n: byte);
    procedure MoveRight(const n: byte);
    procedure MoveLeft(const n: byte);
    procedure SetArrowsVisibility(a, b: boolean); virtual; abstract;
  end;

  TPiano_1 = class(TPiano)
    const nKeys = 24;
    constructor Create;
  private

  public
    procedure SetArrowsVisibility(a, b: boolean); override;
  end;

  TPiano_2 = class(TPiano)
    const nKeys = 20;
    constructor Create;
  private

  public
    procedure SetArrowsVisibility(a, b: boolean); override;
  end;

  TEditor = class(TObject)
    constructor Create;
  private
    notesheet: array of MIDI_Note;
    count: integer;
    tempo: word;
    IOfile: TextFile;
    procedure StartRecNote(s: string);
    procedure EndRecNote(s: string);
    procedure StartNote(int: integer);
    procedure EndNote(int: integer);
    function RoundLength(l: single): single;
    procedure AddSign(int: integer; s: string);
    procedure WriteNotes(t: single);
    function NoteToStr(note: byte; l: single; sign: TImage): string;
    function StrToNote(s: string): Midi_note;
  public
    stance: byte;        // 0 - passive, 1 - playing, 2 - waiting, 3 - recording
    procedure WaitRec;
    procedure StartRecording(s: string);
    procedure StartPlaying;
    procedure Stop;
    procedure ClearAll;
    procedure Save(filename: string);
    procedure Load(filename: string);
  end;

var
  Form1: TForm1;
  time, time0: single;
  Piano_Notes: array [1..nNotes] of TPiano_Note;       // масив всіх клавіш фортепіано
  Players: array [1..nPlayers] of ^TMediaPlayer;
  Keyboard1: TPiano_1;                                   // верхня клавіатура
  Keyboard2: TPiano_2;                                 // нижня клавіатура
  Editor: TEditor;                                     // редактор
  fmusic_path: string = 'wav/acoustic/';               // папка, в якій зберігаються музичні файли
  pActive: byte = 1;
  shift_pressed: boolean;
  show_keybinds: boolean;
  show_names: boolean;
  enable_2_keyboards: boolean;
  enable_resize: boolean;

procedure ShiftModeOff;

implementation

{$R *.dfm}

uses Unit2;

procedure TForm1.About1Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:= enable_resize;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, k: byte;
  n: TKey_name;
begin
  caption:= program_name;                        // програмі присвоюється назва
  Application.Title:= program_name;
  Players[1]:= @MediaPlayer1;                    // формується масив вказівників на компоненти, які програють звук
  Players[2]:= @MediaPlayer2;
  Players[3]:= @MediaPlayer3;
  Players[4]:= @MediaPlayer4;
  Players[5]:= @MediaPlayer5;
  Players[6]:= @MediaPlayer6;
  Players[7]:= @MediaPlayer7;
  Players[8]:= @MediaPlayer8;
  n:= C;                                          // створюються усі клавіші фортепіано
  k:= 1;
  for i:= 1 to nNotes do
  begin
    Piano_Notes[i]:= TPiano_Note.Create(n, k);
    if n = B then
    begin
      n:= C;
      inc(k);
    end
    else n:= succ(n);
  end;
  shift_pressed:= false;
  show_keybinds:= true;
  show_names:= true;
  enable_2_keyboards:= false;
  enable_resize:= true;
  Panel1.Top:= bspace;
  Panel1.Width:= 2*bspace + 12*wkey_width;
  Panel1.Height:= 2*bspace + wkey_height;
  Panel2.Width:= 2*bspace + 10*wkey_width;
  Panel2.Height:= 2*bspace + wkey_height;
  Panel2.Top:= Panel1.Top + Panel1.Height + bspace;
  Panel2.Left:= bspace + wkey_width;
  Panel3.Top:= bspace;
  Panel3.Left:= bspace;
  Panel3.Width:= Panel1.Width;
  PanelEditor.Width:= Panel3.Width - 4;
  Width:= Panel1.Width + 3*bspace;
  Height:= Panel1.Height + 5*bspace ;
  enable_resize:= false;
  Keyboard1:= TPiano_1.Create;
  Keyboard1.ShowKeys(Keyboard1.nKeys);
  Keyboard2:= TPiano_2.Create;
  Keyboard2.ShowKeys(Keyboard2.nKeys);
  MysticNote.Top:= bspace;
  MysticNote.Left:= bspace + 12 * wkey_width;
  Editor:= TEditor.Create;
  Image1.BringToFront;
  Image2.BringToFront;
  Image3.BringToFront;
  Image4.BringToFront;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  k: integer;
begin
  k:= -1;
  case key of
    49:  k:= 0;           // 1
    81:  k:= 1;           // Q
    50:  k:= 2;           // 2
    87:  k:= 3;           // W
    51:  k:= 4;           // 3
    69:  k:= 5;           // E
    52:  k:= 6;           // 4
    82:  k:= 7;           // R
    53:  k:= 8;           // 5
    84:  k:= 9;           // T
    54:  k:= 10;          // 6
    89:  k:= 11;          // Y
    55:  k:= 12;          // 7
    85:  k:= 13;          // U
    56:  k:= 14;          // 8
    73:  k:= 15;          // I
    57:  k:= 16;          // 9
    79:  k:= 17;          // O
    48:  k:= 18;          // 0
    80:  k:= 19;          // P
    189: k:= 20;          // -
    219: k:= 21;          // [
    187: k:= 22;          // =
    221: k:= 23;          // ]
    220: k:= 24;          // \
    65:  k:= 100;         // A
    90:  k:= 101;         // Z
    83:  k:= 102;         // S
    88:  k:= 103;         // X
    68:  k:= 104;         // D
    67:  k:= 105;         // C
    70:  k:= 106;         // F
    86:  k:= 107;         // V
    71:  k:= 108;         // G
    66:  k:= 109;         // B
    72:  k:= 110;         // H
    78:  k:= 111;         // N
    74:  k:= 112;         // J
    77:  k:= 113;         // M
    75:  k:= 114;         // K
    188: k:= 115;         // <
    76:  k:= 116;         // L
    190: k:= 117;         // >
    186: k:= 118;         // :
    191: k:= 119;         // ?
    222: k:= 120;         // "
    37:  case pActive of                                      // <--
           1: Keyboard1.MoveLeft(Keyboard1.nKeys);
           2: Keyboard2.MoveLeft(Keyboard2.nKeys);
           12: begin
             if Keyboard1.first_note > 1 then
               Keyboard2.MoveLeft(Keyboard2.nKeys);
             Keyboard1.MoveLeft(Keyboard1.nKeys);
           end;
         end;
    39:  case pActive of                                       // -->
           1: Keyboard1.MoveRight(Keyboard1.nKeys);
           2: Keyboard2.MoveRight(Keyboard2.nKeys);
           12: begin
             if Keyboard2.first_note < 68 then
               Keyboard1.MoveRight(Keyboard1.nKeys);
             Keyboard2.MoveRight(Keyboard2.nKeys);
           end;
         end;
    VK_Shift:  shift_pressed:= true;
  end;
  if k >= 100 then
  begin
    k:= k - 100;
    if (Keyboard2.Keys[k].pNote <> nil) and enable_2_keyboards then
      Keyboard2.Keys[k].KeyDown;
  end
  else if k >= 0 then
  begin
    if Keyboard1.Keys[k].pNote <> nil then
    Keyboard1.Keys[k].KeyDown;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  k: integer;
begin
  k:= -1;
  case key of
    49:  k:= 0;         // 1
    81:  k:= 1;         // Q
    50:  k:= 2;         // 2
    87:  k:= 3;         // W
    51:  k:= 4;         // 3
    69:  k:= 5;         // E
    52:  k:= 6;         // 4
    82:  k:= 7;         // R
    53:  k:= 8;         // 5
    84:  k:= 9;         // T
    54:  k:= 10;         // 6
    89:  k:= 11;         // Y
    55:  k:= 12;         // 7
    85:  k:= 13;         // U
    56:  k:= 14;         // 8
    73:  k:= 15;         // I
    57:  k:= 16;         // 9
    79:  k:= 17;         // O
    48:  k:= 18;         // 0
    80:  k:= 19;         // P
    189: k:= 20;         // -
    219: k:= 21;         // [
    187: k:= 22;         // =
    221: k:= 23;         // ]
    220: k:= 24;         // \
    65:  k:= 100;         // A
    90:  k:= 101;         // Z
    83:  k:= 102;         // S
    88:  k:= 103;         // X
    68:  k:= 104;         // D
    67:  k:= 105;         // C
    70:  k:= 106;         // F
    86:  k:= 107;         // V
    71:  k:= 108;         // G
    66:  k:= 109;         // B
    72:  k:= 110;         // H
    78:  k:= 111;         // N
    74:  k:= 112;         // J
    77:  k:= 113;         // M
    75:  k:= 114;         // K
    188: k:= 115;         // <
    76:  k:= 116;         // L
    190: k:= 117;         // >
    186: k:= 118;         // :
    191: k:= 119;         // ?
    222: k:= 120;         // "
    VK_Shift:  ShiftModeOff;
  end;
  if k >= 100 then
  begin
    k:= k - 100;
    if (Keyboard2.Keys[k].pNote <> nil) and enable_2_keyboards then
      Keyboard2.Keys[k].KeyUp;
  end
  else if k >= 0 then
  begin
    if Keyboard1.Keys[k].pNote <> nil then
    Keyboard1.Keys[k].KeyUp;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form1.SetFocus;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Picture.LoadFromFile(fLeftArrow_p);
  if NLong.Checked then
  begin
    if Keyboard1.first_note > 1 then                  //якщо можна рухатися вліво
      Keyboard2.MoveLeft(Keyboard2.nKeys);
    Keyboard1.MoveLeft(Keyboard1.nKeys);
  end
  else Keyboard1.MoveLeft(Keyboard1.nKeys);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Picture.LoadFromFile(fLeftArrow);
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image2.Picture.LoadFromFile(fRightArrow_p);
  Keyboard1.MoveRight(Keyboard1.nKeys);
end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image2.Picture.LoadFromFile(fRightArrow);
end;

procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image3.Picture.LoadFromFile(fLeftArrow_p);
  Keyboard2.MoveLeft(Keyboard2.nKeys);
end;

procedure TForm1.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image3.Picture.LoadFromFile(fLeftArrow);
end;

procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image4.Picture.LoadFromFile(fRightArrow_p);
  if NLong.Checked then
  begin
    if Keyboard2.first_note < 68 then                   //якщо можна рухатися вправо
      Keyboard1.MoveRight(Keyboard1.nKeys);
    Keyboard2.MoveRight(Keyboard2.nKeys);
  end
  else Keyboard2.MoveRight(Keyboard2.nKeys);
end;

procedure TForm1.Image4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image4.Picture.LoadFromFile(fRightArrow);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Line1.Left > (PanelEditor.Width - 20) then
  begin
    PanelEditor.Width:= PanelEditor.Width + 50;
    NoteLines.Width:= NoteLines.Width + 50;
    Panel3.HorzScrollBar.Position:= Panel3.HorzScrollBar.Range;
  end;
  Line1.Left:= Line1.Left + 2;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  if Editor.stance = 1 then
  begin
    Timer2.Interval:= 0;
    Editor.StartNote(Timer2.Tag);
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if Editor.stance = 1 then
  begin
    Timer3.Interval:= 0;
    Editor.EndNote(Timer3.tag);
  end;
end;

procedure TForm1.TurnMpOff(Sender: TObject);           //звільняє компоненту MediaPlayer, якщо вона вже закінчила програвати файл
var
  i, k: byte;
begin
  for i:= 1 to nPlayers do
    if Sender = Players[i]^ then
    begin
      k:= i;
      break;
    end;
  if ord(Players[k].Mode) = 1 then
  for i:= 1 to nNotes do
    if Piano_Notes[i].numMP = k then
    begin
      Piano_Notes[i].Stop;
      break;
    end;
  Players[k].Notify:= true;
  Players[k].Wait:= false;
end;

procedure TForm1.N1KeyboardClick(Sender: TObject);
begin
  N1Keyboard.Checked:= true;
  enable_2_keyboards:= false;
  pActive:= 1;
  MysticNote.Visible:= false;
  enable_resize:= true;
  Panel1.Width:= 2*bspace + 12*wkey_width;
  Panel2.Top:= Panel1.Top + Panel1.Height + bspace;
  Panel2.Left:= bspace + wkey_width;
  Panel3.Width:= Panel1.Width;
  if Length(Editor.notesheet) = 0 then
  begin
    PanelEditor.Width:= Panel3.Width - 4;
    NoteLines.Width:= PanelEditor.Width - 20;
  end;
  Width:= Panel1.Width + 3*bspace;
  Height:= Panel1.Top + Panel1.Height + 4*bspace ;
  enable_resize:= false;
end;

procedure TForm1.N2KeyboardsClick(Sender: TObject);
begin
  N2Keyboards.Checked:= true;
  enable_2_keyboards:= true;
  pActive:= 1;
  MysticNote.Visible:= false;
  enable_resize:= true;
  Panel1.Width:= 2*bspace + 12*wkey_width;
  Panel2.Top:= Panel1.Top + Panel1.Height - bspace;
  Panel2.Left:= bspace + wkey_width;
  Panel3.Width:= Panel1.Width;
  if Length(Editor.notesheet) = 0 then
  begin
    PanelEditor.Width:= Panel3.Width - 4;
    NoteLines.Width:= PanelEditor.Width - 20;
  end;
  Width:= Panel1.Width + 3*bspace;
  Height:= Panel1.Top + Panel1.Height + Panel2.Height + 3*bspace;
  enable_resize:= false;
end;

procedure TForm1.NAcousticClick(Sender: TObject);
begin
  NAcoustic.Checked:= true;
  fmusic_path:= 'wav/acoustic/';
end;

procedure TForm1.NEditorClick(Sender: TObject);
begin
  NEditor.Checked:= not NEditor.Checked;
  Panel3.Visible:= not Panel3.Visible;
  enable_resize:= true;                          //зміщуємо компоненти
  if NEditor.Checked then
  begin
    Panel1.Top:= 2*bspace + Panel3.Height;
    Panel2.Top:= Panel2.Top + Panel3.Height + bspace;
    Form1.Height:= Form1.Height + Panel3.Height;
  end
  else begin
    Panel1.Top:= bspace;
    Panel2.Top:= Panel2.Top - Panel3.Height - bspace;
    Form1.Height:= Form1.Height - Panel3.Height;
  end;
  enable_resize:= false;
  NPlay.Enabled:= NEditor.Checked;
  Stop1.Enabled:= NEditor.Checked;
  NRecord.Enabled:= NEditor.Checked;
  Clear1.Enabled:= NEditor.Checked;
  NOpen.Enabled:= NEditor.Checked;
  NSave.Enabled:= NEditor.Checked;
end;

procedure TForm1.NElectricClick(Sender: TObject);
begin
  NElectric.Checked:= true;
  fmusic_path:= 'wav/electric/';
end;

procedure TForm1.NHarpsClick(Sender: TObject);
begin
  NHarps.Checked:= true;
  fmusic_path:= 'wav/harpsichord/';
end;

procedure TForm1.NkeybindsClick(Sender: TObject);
var
  i: byte;
begin
  Nkeybinds.Checked:= not Nkeybinds.Checked;
  show_keybinds:= not show_keybinds;
  if show_keybinds then
  begin
    for i:= 0 to Keyboard1.nKeys do
      if not (Keyboard1.Keys[i].pNote = nil) then
        Keyboard1.Keys[i].Keybind.Visible:= true;
    for i:= 0 to Keyboard2.nKeys do
      if not (Keyboard2.Keys[i].pNote = nil) then
        Keyboard2.Keys[i].Keybind.Visible:= true;
  end
  else begin
    for i:= 0 to Keyboard1.nKeys do
      Keyboard1.Keys[i].Keybind.Visible:= false;
    for i:= 0 to Keyboard2.nKeys do
      Keyboard2.Keys[i].Keybind.Visible:= false;
  end;
end;

procedure TForm1.NLongClick(Sender: TObject);
begin
  NLong.Checked:= true;
  enable_2_keyboards:= true;
  enable_resize:= true;
    Panel1.Width:= 2*bspace + 12*wkey_width - bspace + 10;
    MysticNote.Visible:= true;
    Panel2.Top:= Panel1.Top;
    Panel2.Left:= Panel1.Left + Panel1.Width - bspace - 10;
    Panel3.Width:= Panel2.Left + Panel2.Width - Panel1.Left;
    if Length(Editor.notesheet) = 0 then
    begin
      PanelEditor.Width:= Panel3.Width - 4;
      NoteLines.Width:= PanelEditor.Width - 20;
    end;
    Width:= Panel1.Width + Panel2.Width + 2*bspace;
    Height:= Panel1.Top + Panel1.Height + 4*bspace;
  enable_resize:= false;
  pActive:= 12;
  Panel1.BringToFront;
  if Keyboard1.first_note > 48 then
  begin
    Keyboard1.first_note:= 48;
    Keyboard1.ShowKeys(Keyboard1.nKeys);
  end;
  if Keyboard1.Keys[1].pNote.name in [E, A, B] then
    Keyboard2.first_note:= Keyboard1.first_note + 20
  else Keyboard2.first_note:= Keyboard1.first_note + 21;
  Keyboard2.ShowKeys(Keyboard2.nKeys);
end;

procedure TForm1.NnoteNamesClick(Sender: TObject);
var
  i: byte;
begin
  NnoteNames.Checked:= not NnoteNames.Checked;
  show_names:= not show_names;
  if show_names then
  begin
    for i:= 0 to Keyboard1.nKeys do
      if not (Keyboard1.Keys[i].pNote = nil) then
        Keyboard1.Keys[i].Key_name.Visible:= true;
    for i:= 0 to Keyboard2.nKeys do
      if not (Keyboard2.Keys[i].pNote = nil) then
        Keyboard2.Keys[i].Key_name.Visible:= true;
  end
  else begin
    for i:= 0 to Keyboard1.nKeys do
      Keyboard1.Keys[i].Key_name.Visible:= false;
    for i:= 0 to Keyboard2.nKeys do
      Keyboard2.Keys[i].Key_name.Visible:= false;
  end;
end;

procedure TForm1.NOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Editor.Load(OpenDialog1.FileName);
end;

procedure TForm1.NOrganClick(Sender: TObject);
begin
  NOrgan.Checked:= true;
  fmusic_path:= 'wav/organ/';
end;

procedure TForm1.NPlayClick(Sender: TObject);
begin
  Editor.StartPlaying;
end;

procedure TForm1.NRecordClick(Sender: TObject);
begin
  Editor.WaitRec;   //waiting for the first note
end;

procedure TForm1.NRhodesClick(Sender: TObject);
begin
  NRhodes.Checked:= true;
  fmusic_path:= 'wav/rhodes/';
end;

procedure TForm1.NSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Editor.Save(SaveDialog1.FileName);
end;

procedure TForm1.NSynthClick(Sender: TObject);
begin
  NSynth.Checked:= true;
  fmusic_path:= 'wav/synth pad/';
end;

procedure TForm1.PanelMouseEnter(Sender: TObject);
begin
  if NLong.Checked then
  begin
    pActive:= 12;
    Keyboard1.SetArrowsVisibility(true, false);
    Keyboard2.SetArrowsVisibility(false, true);
  end
  else begin
    if Sender = Panel1 then
    begin
      Keyboard1.SetArrowsVisibility(true, true);
      pActive:= 1;
    end
    else begin
      Keyboard2.SetArrowsVisibility(true, true);
      pActive:= 2;
    end;
  end;
end;

procedure TForm1.PanelMouseLeave(Sender: TObject);
begin
  Keyboard1.SetArrowsVisibility(false, false);
  Keyboard2.SetArrowsVisibility(false, false);
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  Editor.Stop;
end;

constructor TPiano_Note.Create(note_name: TKey_Name; oct: byte);
var
  s: string;
begin
  inherited create;
  name:= note_name;
  case note_name of
    C:    s:= 'C' + inttostr(oct);
    C_:   s:= 'C' + inttostr(oct) + '#';
    D:    s:= 'D' + inttostr(oct);
    D_:   s:= 'D' + inttostr(oct) + '#';
    E:    s:= 'E' + inttostr(oct);
    F:    s:= 'F' + inttostr(oct);
    F_:   s:= 'F' + inttostr(oct) + '#';
    G:    s:= 'G' + inttostr(oct);
    G_:   s:= 'G' + inttostr(oct) + '#';
    A:    s:= 'A' + inttostr(oct);
    A_:   s:= 'A' + inttostr(oct) + '#';
    B:    s:= 'B' + inttostr(oct);
  end;
  strName:= s;
  if s[3] = '#' then
    s[3]:= 's';
  s:= s + '.wav';
  fsound:= s;
  if note_name in [C_, D_, F_, G_, A_] then
    color:= black
  else color:= white;
end;

procedure TPiano_Note.PlayNote;
var
  i: byte;
begin
 if numMP = 0 then                                  // якщо нота не програвалася до натискання, то
 begin                                              // шукається вільна компонента MediaPlayer і закріплюється за нотою
  for i := 1 to nPlayers do
    if Players[i].FileName = '' then
    begin
      numMP:= i;
      break;
    end;
  if numMP <> 0 then
  begin
    Players[numMP].FileName:=fmusic_path + fsound;
    Players[numMP].Open;
    Players[numMP].Play;
  end;
 end
 else begin                                          // якщо нота програвалася, то звуковий файл просто перемотується на початок
   Players[numMP].Previous;
   Players[numMP].Play;
 end;
end;

procedure TPiano_Note.Stop;
begin
  if numMP <> 0 then                                 // якщо нота звучить, то
  begin
    Players[numMP].Stop;                             // зупиняється програвання звуку
    Players[numMP].Close;
    Players[numMP].FileName:= '';
    numMP:= 0;
  end;
end;

constructor TPiano_Key.Create(i: byte; pParent: TPanel);
begin
  imgKey:= TImage.Create(nil);               //створюється компонента Image
  with imgKey do
  begin
    if odd(i) then
      begin
        Width:= wkey_width;
        Height:= wkey_height;
        Picture.LoadFromFile(fwhite);
      end
      else begin
        Width:= bkey_width;
        Height:= bkey_height;
        Picture.LoadFromFile(fblack);
      end;
      Top:= bspace;
      Left:= (wkey_width div 2)*(i - 1) + bspace;
      Parent:= pParent;
      Stretch:= true;
  end;
  Keybind:= TLabel.Create(nil);
  if pParent = Form1.Panel1 then
    Keybind.Caption:= keybinds1[i+1]
  else Keybind.Caption:= keybinds2[i+1];
  with Keybind do
  begin
    Parent:= pParent;
    AutoSize:= false;
    Alignment:= taCenter;
    ParentColor:= false;
    Font.Size:= 14;
    Transparent:= true;
    Height:= 30;
    Left:= (wkey_width div 2)*(i - 1) + bspace;
    if odd(i) then
    begin
      Width:= wkey_width;
      Top:= (wkey_height div 7)*6 + bspace;
      Font.Color:= clBlack;
    end
    else begin
      Width:= bkey_width;
      Top:= wkey_height div 3 + bspace;
      Font.Color:= clWhite;
    end;
  end;
  Key_name:= TLabel.Create(nil);
  with Key_name do
  begin
    Parent:= pParent;
    AutoSize:= false;
    Alignment:= taCenter;
    ParentColor:= false;
    ParentFont:= false;
    Font.Size:= 13;
    Font.Style:= [fsItalic];
    Transparent:= true;
    Height:= 30;
    Left:= (wkey_width div 2)*(i - 1) + bspace;
    if odd(i) then
    begin
      Width:= wkey_width;
      Top:= (wkey_height div 7)*5 + bspace;
      Font.Color:= clBlack;
    end
    else begin
      Width:= bkey_width;
      Top:= wkey_height div 6 + bspace;
      Font.Color:= clWhite;
    end;
  end;
end;

procedure TPiano_Key.KeyDown;
begin
  if pNote.pressed = false then                          // працює тільки тоді, коли нота ще не натиснута
  begin
  //  time0:=GetTickCount();
    pNote.pressed:= true;                                // нота натискається, відповідно змінюється малюнок клавіші
    if pNote.color = white then
      imgKey.Picture.LoadFromFile(fwhite_p)
    else imgKey.Picture.LoadFromFile(fblack_p);
    if Editor.stance = 3 then
        Editor.StartRecNote(pNote.strName)
      else if Editor.stance = 2 then
        Editor.StartRecording(pNote.strName);
    pNote.PlayNote;                                       // програється звук
  //  time:=GetTickCount()-time0;
  //  Form1.Edit1.Text:=floattostr(time0);
  end;
end;

procedure TPiano_Key.KeyUp;
begin
  pNote.pressed:= false;                                  // нота відпускається, змінюється зовнішній вигляд
  if pNote.color = white then
    imgKey.Picture.LoadFromFile(fwhite)
  else imgKey.Picture.LoadFromFile(fblack);
  if Editor.stance = 3 then
    Editor.EndRecNote(pNote.strName);
  if not shift_pressed then                               // якщо не натиснута педаль, то
    pNote.Stop;                                           // зупиняється програвання звуку
end;

procedure TPiano_Key.Show;
var
  pos: integer;
begin
  Key_name.Caption:= pNote.strName;
    if pNote.color = black then                             // вираховується позиція чорних нот та підписів на них
    begin
      pos:= trunc((imgKey.Left + wkey_width - bspace)/wkey_width) * wkey_width;
      if (pNote.name = C_) or (pNote.name = F_) then
        pos:= pos - (wkey_width*5 div 12) + bspace;
      if (pNote.name = G_) then
        pos:= pos - (wkey_width div 3) + bspace;
      if (pNote.name = D_) or (pNote.name = A_) then
        pos:= pos - (wkey_width div 4) + bspace;
      imgKey.Left:= pos;
      Keybind.Left:= pos;
      Key_name.Left:= pos;
      imgKey.Visible:= true;
      if show_keybinds then
        Keybind.Visible:= true;
      if show_names then
        Key_name.Visible:= true;
    end;
end;

constructor TPiano_1.Create;
var
  i: byte;
begin
  first_note:= 37;                           // перша нота - до першої октави (С4)
  Setlength(Keys,nKeys);
  i:= 1;
  repeat
    Keys[i]:= TPiano_Key.Create(i, Form1.Panel1);
    if i = (nKeys - 1) then                     // спочатку створюються білі клавіші, потім - чорні
      i:= 0
    else inc(i, 2);
  until i > nKeys;
end;

constructor TPiano_2.Create;
var
  i: byte;
begin
  first_note:= 25;
  Setlength(Keys,nKeys);
  i:= 1;
  repeat
    Keys[i]:= TPiano_Key.Create(i, Form1.Panel2);
    if i = (nKeys - 1) then
      i:= 0
    else inc(i, 2);
  until i > nKeys;
end;

procedure TPiano.ShowKeys(const n: byte);
var
  i, k: byte;
begin
  for i:= 0 to (n div 2) do                    // приховуються всі чорні клавіші
    begin                                          // потім видимими зробляться лише необхідні
      Keys[i*2].imgKey.Visible:= false;
      Keys[i*2].Keybind.Visible:= false;
      Keys[i*2].key_name.Visible:= false;
    end;
  k:= 0;
  i:= first_note;
  if not (Piano_Notes[i].name in [C, F]) then
  begin
    Keys[k].pNote:= @Piano_Notes[i - 1];
    Keys[k].Show;
  end;
  inc(k);
  repeat
    Keys[k].pNote:= @Piano_Notes[i];
    Keys[k].Show;
    if Piano_Notes[i].name in [E, B] then
    begin
      Keys[k+1].pNote:= nil;
      inc(k,2)
    end
    else inc(k);
    inc(i);
  until k > n;
end;

procedure TPiano.MoveRight(const n: byte);
var
  i: byte;
begin
  if Keys[n-1].pNote <> @Piano_Notes[nNotes] then       //здійснити рух можна, тільки якщо це не крайня права позиція
  begin
    if Keys[1].pNote.name in [B, E] then
      inc(first_note)
    else inc(first_note, 2);
    for i:= 0 to n do
      Keys[i].pNote:= nil;
    ShowKeys(n);
  end;
end;

procedure TPiano.MoveLeft(const n: byte);
var
  i: byte;
begin
  if Keys[1].pNote <> @Piano_Notes[1] then                 // здійснюємо рух, тільки якщо ми зараз не в крайній лівій позиції
  begin
    if Keys[1].pNote.name in [C, F] then
      dec(first_note)
    else dec(first_note, 2);
    for i:= 0 to n do
      Keys[i].pNote:= nil;
    ShowKeys(n);
  end;
end;

procedure TPiano_1.SetArrowsVisibility(a: Boolean; b: Boolean);
begin
  Form1.Image1.Visible:= a;
  Form1.Image2.Visible:= b;
end;

procedure TPiano_2.SetArrowsVisibility(a: Boolean; b: Boolean);
begin
  Form1.Image3.Visible:= a;
  Form1.Image4.Visible:= b;
end;

constructor TEditor.Create;
begin
  count:= 0;
  stance:= 0;
  tempo:= 120;
end;

procedure TEditor.WaitRec;
begin
  stance:= 2;
  ClearAll;
  Form1.Line1.Left:= 48;
  Form1.Panel3.HorzScrollBar.Position:= 0;
  Form1.Timer1.Interval:= 0;
end;

procedure TEditor.StartRecording(s: string);
begin
  stance:= 3;
  time0:= GetTickCount();
  Form1.Timer1.Interval:= round(tempo/6);
  startrecnote(s);
end;

procedure TEditor.StartPlaying;
begin
  if Length(notesheet) > 0 then
  begin
  stance:= 1;
  Form1.Line1.Left:= 48;
  Form1.Panel3.HorzScrollBar.Position:= 0;
  Form1.Timer1.Interval:= round(tempo/6);
  Form1.Timer2.Tag:= 0;
  Form1.Timer3.Tag:= 0;
  Form1.Timer3.Interval:= round((notesheet[0].Tend - notesheet[0].Tstart)*60000/tempo) + 70;
  StartNote(0);
  end;
end;

procedure TEditor.Stop;
var
  i: integer;
begin
  if stance <> 0 then
  begin
    if stance = 1 then
      for i:= 1 to nNotes do
        if not Piano_Notes[i].pressed then
          Piano_Notes[i].Stop;
    stance:= 0;
    Form1.Timer1.Interval:= 0;
  end;
end;

procedure TEditor.StartRecNote(s: string);
begin
  inc(count);
  SetLength(notesheet, count);
  with notesheet[count-1] do
  begin
    Tstart:= (GetTickCount() - time0)*tempo/60000;
    Tstart:= round(Tstart*4)/4;
    case s[1] of
      'C': note:= 1;
      'D': note:= 3;
      'E': note:= 5;
      'F': note:= 6;
      'G': note:= 8;
      'A': note:= 10;
      'B': note:= 12;
    end;
    note:= note + (strtoint(s[2]) - 1)*12;
    if s[3] = '#' then
      inc(note);
    image:= TImage.Create(nil);
    image.Parent:= Form1.PanelEditor;
    case s[1] of
      'C': image.Top:= 30;
      'D': image.Top:= 25;
      'E': image.Top:= 20;
      'F': image.Top:= 15;
      'G': image.Top:= 10;
      'A': image.Top:= 5;
      'B': image.Top:= 0;
    end;
    image.Top:= image.Top - 95 + (7 - strtoint(s[2]))*35;
    image.Left:=Form1.Line1.Left;
    image.Height:= 39;
    image.Width:= 25;
    image.Proportional:= true;
    image.Stretch:= true;
   end;
end;

procedure TEditor.EndRecNote(s: string);
var
  i, j: integer;
  noteNum: integer;
begin
  case s[1] of
    'C': noteNum:= 1;
    'D': noteNum:= 3;
    'E': noteNum:= 5;
    'F': noteNum:= 6;
    'G': noteNum:= 8;
    'A': noteNum:= 10;
    'B': noteNum:= 12;
  end;
  noteNum:= noteNum + (strtoint(s[2]) - 1)*12;
  if s[3] = '#' then
    inc(noteNum);
  for i:= 0 to (count - 1) do
  begin
    if (notesheet[i].note = noteNum) and (notesheet[i].Tend = 0) then
      break;
  end;
  if i <= (count - 1) then
    with notesheet[i] do
    begin
      Tend:= GetTickCount() - time0;
      length:= RoundLength(Tend*tempo/60000 - Tstart);
      image.Picture.LoadFromFile('img\notes\' + floattostr(length) + '.png');
      Tend:= Tstart + length;
    end;
    j:= -1;
  if count > 2 then                                                     //вставка знаку дієза, бемоля або бекара
    for j:= (count - 2) downto 0 do
      if notesheet[j].image.Top = notesheet[i].image.Top then
        break;
  if j >= 0 then
  begin
    if noteNum <> notesheet[j].note then
    begin
      if s[3] <> '#' then
        AddSign(i, 'natural')
      else AddSign(i, 'sharp');
    end;
  end
  else if s[3] = '#' then
    AddSign(i, 'sharp');
end;

procedure TEditor.StartNote(int: Integer);
begin
  if Piano_Notes[notesheet[int].note].pressed then
    Piano_Notes[notesheet[int].note].Stop;
  Piano_Notes[notesheet[int].note].PlayNote;
  Form1.Timer2.Tag:= int + 1;
  if int < (count - 1) then
  begin
    if (notesheet[int+1].Tstart - notesheet[int].Tstart) > 0 then
      Form1.Timer2.Interval:= round((notesheet[int+1].Tstart - notesheet[int].Tstart)*60000/tempo) - 50
    else StartNote(int + 1);
  end;
end;

procedure TEditor.EndNote(int: Integer);
var
  i, min, max: integer;
  value: single;
begin
  Piano_Notes[notesheet[int].note].Stop;
  min:= 0;
  value:= 0;
  for i:= 0 to (count - 1) do
    if notesheet[i].Tend > value then
    begin
      max:= i;
      value:= notesheet[i].Tend;
    end;
  if value = notesheet[int].Tend then
  begin
      Stop;
      Form1.Timer2.Interval:= 0;
  end
  else begin
    for i:= 1 to (count - 1) do
      if (notesheet[i].Tend > notesheet[int].Tend) and (notesheet[i].Tend < value) then
      begin
        min:= i;
        value:= notesheet[i].Tend;
      end;
    if min > 0 then
    begin
      if (notesheet[min].Tend - notesheet[int].Tend) > 0 then
      begin
        Form1.Timer3.Tag:= min;
        Form1.Timer3.Interval:= round((notesheet[min].Tend - notesheet[int].Tend)*60000/tempo) + 30;
      end
      else EndNote(min);
    end
    else begin
      Form1.Timer3.Tag:= max;
      Form1.Timer3.Interval:= round((value - notesheet[int].Tend)*60000/tempo) + 30;
    end;
  end;
end;

procedure TEditor.ClearAll;
var
  i: integer;
begin
  if count > 0 then
    for i:= 0 to (count - 1) do
    begin
      notesheet[i].image.Free;
      if notesheet[i].sign <> nil then
        notesheet[i].sign.Free;
    end;
  count:= 0;
  SetLength(notesheet, 0);
  Form1.PanelEditor.Width:= Form1.Panel3.Width - 4;
  Form1.NoteLines.Width:= Form1.PanelEditor.Width - 20;
end;

procedure TEditor.Save(filename: string);
begin
  if pos('.', Form1.SaveDialog1.FileName) = 0 then
    Form1.SaveDialog1.FileName:= Form1.SaveDialog1.FileName + '.abc';
  AssignFile(IOfile, Form1.SaveDialog1.FileName);
  Rewrite(IOfile);
  Append(IOfile);
  WriteNotes(0);
  CloseFile(IOfile);
end;

procedure TEditor.Load(filename: string);
var
  s1, s2: string;
  t, tmp: single;
  Tfile: TextFile;
  i: integer;
begin
  ClearAll;
  AssignFile(Tfile, fileName);
  Reset(Tfile);
  t:= 0;
  repeat
    readln(Tfile, s1);
  until s1 = '';
  repeat
    Readln(Tfile, s1);
    while s1 <> '' do
    begin
      if pos(' ', s1) <> 0 then
      begin
        s2:= copy(s1, 1, pos(' ', s1) - 1);
        s1:= copy(s1, pos(' ', s1) + 1, length(s1));
      end
      else begin
        s2:= s1;
        s1:= '';
      end;
      if s2[1] = 'z' then
      begin
        s2:= copy(s2, 2, length(s2)-1);
        if pos('/', s2) <> 0 then
        begin
          tmp:= 1/strtoint(copy(s2,pos('/', s2),2));
          s2:= copy(s2, 1, pos('/', s2) - 1);
        end
        else tmp:= 1;
        if s2 <> '' then
          tmp:= tmp*strtoint(s2);
        t:= t + tmp;
      end
      else begin
        inc(count);
        SetLength(notesheet, count);
        if s2[1] in ['^', '_', '='] then
          notesheet[count - 1]:= StrtoNote(copy(s2, 2, length(s2)))
        else notesheet[count - 1]:= StrtoNote(s2);
        with notesheet[count - 1] do
        begin
          tstart:= t;
          tend:= tstart + length;
          image:= TImage.Create(nil);
          image.Parent:= Form1.PanelEditor;
          case (note mod 12) of
            1,2: image.Top:= 30;
            3,4: image.Top:= 25;
            5:   image.Top:= 20;
            6,7: image.Top:= 15;
            8,9: image.Top:= 10;
            10,11:image.Top:= 5;
            12:  image.Top:= 0;
          end;
          image.Top:= image.Top - 95 + (6 - ((note - 1) div 12))*35;
          image.Left:= round(t*12*60000/(tempo*tempo)) + 48;
          image.Height:= 39;
          image.Width:= 25;
          image.Proportional:= true;
          image.Stretch:= true;
          image.Picture.LoadFromFile('img\notes\' + floattostr(length) + '.png');
          if s2[1] in ['^', '_', '='] then
          begin
            case s2[1] of
              '^': AddSign(count - 1, 'sharp');
              '_': AddSign(count - 1, 'flat');
              '=': AddSign(count - 1, 'natural');
            end;
            note:= note + sign.tag;
          end
          else if count > 2 then
          begin
            for i:= (count - 2) downto 0 do
              if (notesheet[i].image.Top = image.top) and (notesheet[i].sign <> nil) then
                break;
            if i > 0 then
              note:= note + notesheet[i].sign.Tag;
          end;
        end;
        t:= t + notesheet[count - 1].length;
      end;
    end;
  until eof(Tfile);
  CloseFile(Tfile);
end;

procedure TEditor.WriteNotes(t: Single);
var
  i, first: integer;
  k: byte;
  tmin: single;
  s: string;
begin
  first:= -1;
  for i:= 0 to count - 1 do
    if notesheet[i].Tstart = t then
    begin
      first:= i;
      break;
    end;
  k:= 0;
  if first >= 0 then
  begin
    repeat
      s:= s + notetostr(notesheet[first + k].note, notesheet[first + k].length, notesheet[first + k].sign);
      inc(k);
    until ((first + k) >= count) or (notesheet[first + k].Tstart > t);
    tmin:= notesheet[first].Tend;
    for i:= first to (first + k - 1) do
      if tmin > notesheet[i].Tend then
        tmin:= notesheet[i].Tend;
    if (tmin > notesheet[first + k].Tstart) and ((first + k) < count) then
    begin
      tmin:= notesheet[first + k].Tstart;
      s:= s + notetostr(0, tmin - t, nil);
      inc(k);
    end;
    if k > 1 then
      s:= '[' + s + ']';
  end
  else begin
    for i:= 0 to count - 1 do
      if notesheet[i].Tstart > t then
      begin
        tmin:= notesheet[i].Tstart;
        break;
      end;
    s:= notetostr(0, tmin - t, nil);
  end;
  s:= s + ' ';
  tmin:=round(tmin*4)/4;
  Write(IOfile, s);
  if (first + k) < count then
    writeNotes(tmin);
end;

function TEditor.RoundLength(l: Single): single;
begin
  if l < 0.4 then
    RoundLength:= 0.25
  else if l < 0.7 then
    RoundLength:= 0.5
  else if l < 0.85 then
    RoundLength:= 0.75
  else if l < 1.4 then
    RoundLength:= 1
  else if l < 1.7 then
    RoundLength:= 1.5
  else if l < 2.8 then
    RoundLength:= 2
  else if l < 3.4 then
    RoundLength:= 3
  else if l < 5 then
    RoundLength:= 4
  else RoundLength:= 6;
end;

procedure TEditor.AddSign(int: integer; s: string);
begin
  with notesheet[int] do
  begin
    sign:= TImage.Create(nil);
    sign.Parent:= Form1.PanelEditor;
    sign.Top:= image.Top + 18;
    sign.Left:= image.Left - 14;
    sign.Height:= 26;
    sign.Width:= 15;
    sign.Proportional:= true;
    sign.Stretch:= true;
    sign.Picture.LoadFromFile('img\notes\' + s + '.png');
    if s = 'natural' then
      sign.Tag:= 0
    else if s = 'sharp' then
      sign.Tag:= 1
    else sign.Tag:= -1;
  end;
end;

function TEditor.NoteToStr(note: Byte; l: Single; sign: TImage): string;
var
  s: string;
begin
  if note = 0 then
    s:= 'z'
  else begin
    case (note mod 12) of
      0:    s:='B';
      1, 2: s:='C';
      3, 4: s:='D';
      5:    s:='E';
      6, 7: s:='F';
      8, 9: s:='G';
      10,11:s:='A';
    end;
    case ((note-1) div 12) of
      0: s:= s + ',,,';
      1: s:= s + ',,';
      2: s:= s + ',';
      4: s:= ANSILowerCase(s);
      5: s:= ANSILowerCase(s) + #39;
      6: s:= ANSILowerCase(s) + #39 + #39;
    end;
    if sign <> nil then
      case sign.Tag of
        -1: s:= '_' + s;
        0:  s:= '=' + s;
        1:  s:= '^' + s;
      end;
  end;
  if trunc(l) = l then
  begin
    if l <> 1 then
      s:= s + floattostr(l);
  end
  else if trunc(l*2) = l*2 then
  begin
    if l*2 <> 1 then
      s:= s + inttostr(trunc(l*2));
    s:= s + '/2';
  end
  else begin
    if l*4 <> 1 then
      s:= s + inttostr(trunc(l*4));
    s:= s + '/4';
  end;
  NoteToStr:= s;
end;

function TEditor.StrToNote(s: string): Midi_note;
var
  mnote: Midi_note;
begin
  //returns note num and length, start and end are calculated in load;
  case s[1] of
    'C': mnote.note:= 37;
    'D': mnote.note:= 39;
    'E': mnote.note:= 41;
    'F': mnote.note:= 42;
    'G': mnote.note:= 44;
    'A': mnote.note:= 46;
    'B': mnote.note:= 48;
    'c': mnote.note:= 49;
    'd': mnote.note:= 51;
    'e': mnote.note:= 53;
    'f': mnote.note:= 54;
    'g': mnote.note:= 56;
    'a': mnote.note:= 57;
    'b': mnote.note:= 59;
  end;
  s:= copy(s,2,length(s));
  while (s <> '') and (s[1] in [',', #39])  do
  begin
    if s[1] = ',' then
      mnote.note:= mnote.note - 12
    else mnote.note:= mnote.note + 12;
    s:= copy(s,2,length(s));
  end;
  if pos('/', s) <> 0 then
  begin
    mnote.length:= 1/strtoint(copy(s,pos('/', s) + 1, 2));
    s:= copy(s, 1, pos('/', s) - 1);
  end
  else mnote.length:= 1;
  if s <> '' then
    mnote.length:= mnote.length*strtoint(s);
  StrToNote:= mnote;
end;

procedure ShiftModeOff;                        // при відпусканні педалі всі клавіші, які не натиснуті зараз, перестають звучати
var
  i: byte;
begin
  shift_pressed:= false;
  for i:= 1 to nNotes do
    if not Piano_Notes[i].pressed then
      Piano_Notes[i].Stop;
end;

end.
