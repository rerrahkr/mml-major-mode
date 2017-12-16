(require 'generic-x)


; 追加face定義
(defface pmd-part
'((t (:foreground "maroon" :bold t)))
  "face of part in MML for PMD")
(defvar pmd-part 'pmd-part)
(defface pmd-pan
  '((t (:foreground "DarkGoldenrod")))
  "face of pan in MML for PMD")
(defvar pmd-pan 'pmd-pan)
(defface pmd-volume
  '((t (:foreground "red1")))
  "face of volume in MML for PMD")
(defvar pmd-volume 'pmd-volume)
(defface pmd-move
  '((t (:foreground "DodgerBlue3")))
  "face of move in MML for PMD")
(defvar pmd-move 'pmd-move)


; Major Mode定義
(define-generic-mode pmd-mode
  ;; コメント
  '(";")
  
  ;; キーワード
  nil
  
     ;; 設定チャンネル
  '(("#\\(Filename\\|PCMFile\\|Option\\|Title\\).*$" . font-lock-builtin-face)
    ("#\\(Composer\\|Arranger\\|Memo\\|Tempo\\).*$" . font-lock-builtin-face)
    ("#\\(Timer\\|Zenlen\\|Detune\\|LFOSpeed\\).*$" . font-lock-builtin-face)
    ("#\\(EnvelopeSpeed\\|PCMVolume\\|FM3Extend\\).*$" . font-lock-builtin-face)
    ("#\\(Volumedown\\|ADPCM\\|Transpose\\|Octave\\).*$" . font-lock-builtin-face)
    ("#\\(LoopDefault\\|DT2Flag\\|Bendrange\\).*$" . font-lock-builtin-face)
    ("#\\(PPSFile\\|PPCFile\\|FFFile\\|Jump\\).*$" . font-lock-builtin-face)
    ("#\\(PPZExtend\\|PPZFile\\|Include\\).*$" . font-lock-builtin-face)
    ("Z[0-9]\\{1,3\\}\\|~[+-]?[0-9]\\{1,3\\}" . font-lock-builtin-face)
    
    ;; 各パート
    ("^[A-QS-Z]+\\|^R[0-9]\\{1,3\\}" . pmd-part)

    ;; 条件コンパイル
    ("|!?\\([A-Z]+\\)?" . pmd-part)

    ;; 音量
    ("\\\\V[+-]?[0-9]\\{1,2\\}\\|\\\\v[bchist][+-]?[0-9]\\{1,2\\}" . pmd-volume)
    ("v[0-9]\\{1,2\\}\\|V[0-9]\\{1,3\\}\\|v[+-]?[0-9]\\{1,3\\}" . pmd-volume)
    ("v[()][0-9]\\{1,2\\}\\|[()]\\^?%?\\([0-9]\\{1,3\\}\\)?" . pmd-volume)
    ("D[FPRS][+-]?[0-9]\\{1,3\\}" . pmd-volume)

    ;; フェードアウト
    ("F[0-9]\\{1,3\\}" . pmd-volume)

    ;; LFO
    ("MW[AB]?[0-6]\\|\\*[AB]?[0-7]\\(,[AB]?[0-7]\\)?" . font-lock-constant-face)
    ("MM[AB]?[0-9]\\{1,2\\}\\|MX[AB]?[01]" . font-lock-constant-face)
    ("M[AB]?l?[0-9]\\{1,3\\}\\.*\\(,[+-]?[0-9]\\{1,3\\}\\)\\{3\\}?" . font-lock-constant-face)
    ("MP[AB]?[+-]?[0-9]\\{1,3\\}\\(,l?[0-9]\\{1,3\\}\\.*\\(,[0-9]\\{1,3\\}\\)?\\)?" . font-lock-constant-face)
    ("MD[AB]?[0-9]\\{1,3\\}\\(,[+-]?[0-9]\\{1,3\\}\\(,[0-9]\\{1,3\\}\\)?\\)?" . font-lock-constant-face)
    ("H[0-7]\\(,[0-3]\\)?\\(,l?[0-9]\\{1,3\\}\\.*\\)?" . font-lock-constant-face)
    ("#[01]\\(,[0-7]\\)?\\|#[fa][0-9]\\{1,3\\}" . font-lock-constant-face)
    ("##[0-9]\\{1,3\\},[0-3],[+-]?[0-9]\\{1,2\\},[0-9]\\{1,3\\}" . font-lock-constant-face)
    ("#w[0-3]\\|#p[+-]?[0-9]\\{1,2\\}\\|#Dl?[0-9]\\{1,3\\}\\.*" . font-lock-constant-face)
    
    ;; 音色設定系
    ("^@[ \t,]*[0-9]\\{1,3\\}\\([ \t,]+[0-9]\\{1,3\\}\\)\\{2\\}\\([ \t]=.+\\)?" . font-lock-keyword-face)
    ("^\\([ \t,]+[+-]?[0-9]\\{1,3\\}\\)\\{10,11\\}" . font-lock-keyword-face)
    ("@[0-9]\\{1,3\\}" . font-lock-keyword-face)
    ("E[ \t]*[0-9]\\{1,2\\}\\(,[ \t]*[0-9]\\{1,2\\}\\)\\{4,5\\}" . font-lock-keyword-face)
    ("E[ \t]*[0-9]\\{1,3\\},[ \t]*[+-]?[0-9]\\{1,2\\}\\(,[ \t]*[0-9]\\{1,3\\}\\)\\{2\\}" . font-lock-keyword-face)
    ("EX[01]\\|\\\\[bchist]p?" . font-lock-keyword-face)
    ("y\\$?[0-9A-Fa-f]\\{1,3\\},\\$?[0-9A-Fa-f]\\{1,3\\}\\|s[0-9]\\{1,2\\}" . font-lock-keyword-face)
    ("O[0-9]\\{1,2\\},[+-]?[0-9]\\{1,2\\}\\|FB[+-]?[0-7]" . font-lock-keyword-face)
    ("s[0-9]\\{1,2\\}\\|P[1-3]\\|w[+-]?[0-9]\\{1,2\\}" . font-lock-keyword-face)
    ("[Nn][0-9]\\{1,3\\}\\|A[01]" . font-lock-keyword-face)

    ;; パン
    ("p[0-3]\\|px[01]\\|px[+-][0-9]\\{1,3\\}" . pmd-pan)
    ("\\\\[lmr][bchist]" . pmd-pan)

    ;; オクターブ、移調、転調
    ("o[1-8]\\|[X<>]" . font-lock-function-name-face)
    ("o[+-][1-7]\\|__?[+-]?[0-9]\\{1,3\\}" . font-lock-function-name-face)
    ("_{[+-=][a-g]+}\\|_M[+-]?[0-9]\\{1,3\\}" . font-lock-function-name-face)

    ;; デチューン、ピッチベンド
    ("DD?[+-]?[0-9]\\{1,5\\}\\|sdd?[0-9]\\{1,2\\},[0-9]\\{1,5\\}" . font-lock-function-name-face)
    ("DX[01]\\|B[0-9]\\{1,3\\}\\|I[+-]?[0-9]\\|DM[+-]?[0-9]" . font-lock-function-name-face)

    ;; ポルタメント
    ("{\\|}\\(%?[0-9]\\{1,3\\}\\.*\\(,[0-9]\\{1,3\\}\\.*\\)?\\)?" . font-lock-function-name-face)

    ;; テンポ
    ("t[+-]?[0-9]\\{2,3\\}\\|T[+-]?[0-9]\\{1,3\\}" . pmd-move)

    ;; ループ
    ("L\\|\\[\\|:\\|\\][0-9]\\{1,3\\}?" . pmd-move)

    ;; 装飾音符
    ("Sl?[0-9]\\{1,3\\}\\.*\\(,[+-]?[0-9]\\{1,3\\}\\(,[01]\\)?\\)?" . pmd-move)

    ;; 疑似エコー、ディレイ
    ("Wl?[0-9]\\{1,3\\}\\.*\\(,%?[+-]?[0-9]\\{1,3\\}\\(,[0-3]\\)?\\)?" . pmd-move)
    ("sk[0-9]\\{1,2\\}\\(,l?[0-9]\\{3\\}\\)?" . pmd-move)
    
    ;; 音長
    ("l%?[0-9]\\{1,3\\}\\.*\\|C[0-9]\\{1,3\\}" . font-lock-type-face)

    ;; ゲートタイム
    ("Q\\([0-8]\\|%[0-9]\\{1,3\\}\\)" . font-lock-type-face)
    ("q[0-9]\\{1,3\\}\\(-[0-9]\\{1,3\\}?\\)?\\(,[0-9]\\{1,3\\}\\)?" . font-lock-type-face)
    ("q[0-9]\\{1,3\\}\\.*\\(-\\([0-9]\\{1,3\\}\\.*\\)?\\)?\\(,[0-9]\\{1,3\\}\\.*\\)?" . font-lock-type-face)
    
    ;; タイ、スラー
    ;("&&?" . font-lock-type-face)
    
    ;; マクロ
    ("^![0-9A-Za-z]+" . font-lock-variable-name-face)

    ;; リズムパターン
    ("R[0-9]\\{1,3\\}" . font-lock-variable-name-face)

    ;; パートマスク
    ("m[01]" . font-lock-warning-face)

    ;; コンパイル打ち切り
    ("/" . font-lock-warning-face))

  ;; 適用ファイル拡張子
  '("\\.mml$")

  ;; hook
  nil

  ;; 説明
  "Major mode of MML for PMD")


(provide 'pmd-mode)
