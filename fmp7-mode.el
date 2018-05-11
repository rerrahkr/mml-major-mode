(require 'generic-x)


; 追加face定義
(defface fmp7-part
  '((t (:foreground "maroon" :bold t)))
  "face of part in MML for FMP7")
(defvar fmp7-part 'fmp7-part)
(defface fmp7-pan
  '((t (:foreground "DarkGoldenrod")))
  "face of panpot in MML for FMP7")
(defvar fmp7-pan 'fmp7-pan)
(defface fmp7-volume
  '((t (:foreground "red1")))
  "face of volume in MML for FMP7")
(defvar fmp7-volume 'fmp7-volume)
(defface fmp7-move
  '((t (:foreground "DodgerBlue3")))
  "face of moves in MML for FMP7")
(defvar fmp7-move 'fmp7-move)


; Major Mode定義
(define-generic-mode fmp7-mode
  ;; コメント
  '(";")
  
  ;; キーワード
  nil

    ;; 調号設定
  '(("{[+-=]\\([a-g]+\\|\\*\\)}" . font-lock-function-name-face)

    ;; 設定チャンネル
    ("^'{\\|}$\\|\\(Title\\|DataCreator\\|Composer\\|Comment\\)=.*" . font-lock-builtin-face)
    ("\\(Part\\(OPNA\\|OPM\\|SSG\\|PCM\\|MixLevel\\)\\|ClockCount\\)=.*" . font-lock-builtin-face)
    ("\\(SSGMixLevel\\|VolumeExtend\\|PitchOctaveKeep\\)=.*" . font-lock-builtin-face)
    
    ;; 各パート
    ("^'\\([A-Z][0-9]*\\(-[0-9]*\\)?\\)+" . fmp7-part)

    ;; 条件コンパイル
    ("\\?\\([A-Z][0-9]*\\(-[0-9]*\\)?:\\)+\\|\\?!:\\|\\?:" . fmp7-part)

    ;; 音色設定系
    ("^'@[ \t]*F[AC]?[ \t]*[0-9]\\{1,3\\}" . font-lock-keyword-face)
    ("^'@\\([ \t,]+[0-9]\\{1,3\\}\\)\\{9,11\\}" . font-lock-keyword-face)
    ("^'@\\([ \t,]+[0-7]\\)\\{2\\}" . font-lock-keyword-face)
    ("^'@[ \t]*P[ \t]*[0-9]\\{1,3\\}," . font-lock-keyword-face)
    (",i[0-9]\\{1,5\\}\\(,[dl][es]\\(0x\\)?[0-9A-Fa-f]\\{1,8\\}\\)\\{,4\\}\\(,r[0-9]\\{1,5\\}\\)?\\(,fl\\)?" . font-lock-keyword-face)
    ("^'@[ \t]*EX?[ \t]*[0-9]\\{1,3\\}\\([ \t,]+[0-9]\\{1,3\\}\\)\\{6,13\\}" . font-lock-keyword-face)
    ("@\\([0-3],[0-9]\\|[0-9]\\{1,3\\}\\)" . font-lock-keyword-face)
    ("_@[0-9]\\{1,3\\},[0-9]\\{1,5\\}\\([01],[0-2]\\(,[0-9]\\{1,5\\}\\)\\{2\\}\\)?" . font-lock-keyword-face)
    ("y\\(\\([ARS]\\|D[12]?\\)R\\|\\([ST]\\|D1\\)L\\|KS\\|ML\\|DT[12]?\\)\\(,[1-4]\\)?,[0-9]\\{1,3\\}" . font-lock-keyword-face)
    ("y\\(AM\\|AL\\|FB\\|LFREQ\\|LWAVE\\|PMD\\|AMD\\|PMS\\|AMS\\)\\(,[1-4]\\)?,[0-9]\\{1,3\\}" . font-lock-keyword-face)
    ("E[0-9]\\{1,3\\}\\|EH[0-9]\\{1,2\\},[0-9]\\{1,5\\}" . font-lock-keyword-face)
    ("l?w[0-9]\\{1,2\\}\\|w[()][0-9]\\{1,2\\}?\\|m[01],[01]" . font-lock-keyword-face)

    ;; 外部ファイル
    ("^'<.+>" . font-lock-variable-name-face)

    ;; スタック
    ("\\([DKPQlmoqvw@]\\|l[DKPTvw]\\|EH?\\|M[PQRS][HNPTVW]\\)[<>]" . font-lock-warning-face)

    ;; LFO
    ("M[PQRS]\\([NPTV]\\|W[1-4]\\)[0-9]\\{1,3\\},[0-9]\\{1,3\\}\\(,[+-]?[0-9]\\{1,5\\}\\)\\{2\\}\\(,[0-4]\\(,[01]\\(,[+-]?[0-9]\\{1,5\\}\\)?\\)?\\)?" . font-lock-constant-face)
    ("M[PQRS]H[0-9]\\{1,3\\},\\([0-7]\\|[0-3]\\(,[0-9]\\{1,3\\}\\)\\{3\\}\\),[0-7],[0-3]\\(,[01]\\)?" . font-lock-constant-face)
    ("S[PQRS][0-2]\\|D[PQRS][0-9]\\{1,3\\}" . font-lock-constant-face)
    
    ;; パン
    ("l?P[0-9]\\{1,3\\}\\|P[LR()][0-9]\\{1,3\\}?\\|PC" . fmp7-pan)

    ;; オクターブ、移調
    ("o[1-8]\\|[<>]\\|lK[0-9]\\{1,2\\}" . font-lock-function-name-face)
    ("K[+-]?[0-9]\\{1,2\\}\\|K[()][0-9]\\{1,2\\}?" . font-lock-function-name-face)
    
    ;; デチューン
    ("D[+-]?[0-9]\\{1,4\\}\\|D[()][0-9]\\{1,4\\}?" . font-lock-function-name-face)
    ("lD[0-9]\\{1,4\\}\\|SD[+-]?[0-9]\\{1,4\\}\\(,[+-]?[0-9]\\{1,4\\}\\)\\{3\\}" . font-lock-function-name-face)
    ;("D.?[0-9]+\\|D(.?[0-9]+\\|D).?[0-9]+" . font-lock-function-name-face)

    ;; ピッチベンド
    ("_" . font-lock-function-name-face)

    ;; 音量
    ("l?v[0-9]\\{1,3\\}\\|[()][0-9]\\{1,3\\}?" . fmp7-volume)
    ("V[+-]?[0-9]\\{1,3\\}" . fmp7-volume)

    ;; フェードアウト
    ("F[0-9]\\{1,3\\}\\(,[0-9]\\{1,3\\}\\)\\{2\\}" . fmp7-volume)
    
    ;; 音長
    ("l[0-9]\\{1,3\\}\\.*" . font-lock-type-face)

    ;; ゲートタイム
    ("Q[1-8]\\|q[0-9]\\{1,5\\}" . font-lock-type-face)

    ;; タイ、スラー
    ;("&\\|\\^" . font-lock-type-face)

    ;; テンポ
    ("\\(T[()]?\\|lT\\)[0-9]\\{1,3\\}" . fmp7-move)

    ;; ループ
    ("L\\|\\[\\|/\\(/\\|[0-9]\\{1,3\\}\\)?\\|\\][0-9]\\{1,3\\}?" . fmp7-move)

    ;; 装飾音符
    ("\\$" . fmp7-move)

    ;; ディレイ
    ("R[0-9]\\{1,3\\}\\.*\\|RS" . fmp7-move)

    ;; エイリアス
    ("^'%[0-9A-Za-z]+" . font-lock-variable-name-face)

    ;; コンパイル打ち切り、演奏スキップ
    ("![01]?" . font-lock-warning-face))

  ;; 適用ファイル拡張子
  '("\\.mwi\\'")

  ;; hook
  nil

  ;; 説明
  "Major mode of MML for FMP7")


(provide 'fmp7-mode)
