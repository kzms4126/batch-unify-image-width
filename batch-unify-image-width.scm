; batch-unify-image-width
; Copyright (C) 2018 Masakazu Kobayashi
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
;
; イメージ幅統一スクリプト
; ファイルパターンにマッチするファイルを、縦横比を維持したまま指定した幅(px)になるよう拡大・縮小します。
;
; 【使い方】
; gimp-2.8 -i -b "(batch-unify-image-width \"ファイルパターン\" \"出力フォルダ\" 新しいイメージ幅)" -b "(gimp-quit 0)"
;
; 【例】
; ファイルパターン c:\users\test\Desktop\temp\*.jpg に合致するファイルを幅 650px に拡大・縮小
; c:\users\test\Desktop\temp\output に出力します。
; gimp-2.8 -i -b "(batch-unify-image-width \"c:\\users\\test\\Desktop\\temp\\*.jpg\" \"c:\\users\\test\\Desktop\\temp\\output\" 650)" -b "(gimp-quit 0)"
;
;
; Script for unify image width
; Scales the file that matches the file pattern to the specified width (px) while maintaining the aspect ratio.
;
; <Command>
; gimp-2.8 -i -b "(batch-unify-image-width \"[FilePattern]\" \"[OutputFolder]\" [NewImageWidth])" -b "(gimp-quit 0)"
;
; <Example>
; FilePattern   -> c:\users\test\Desktop\temp\*.jpg
; OutputFolder  -> c:\users\test\Desktop\temp\output
; NewImageWidth -> 650px
;
; gimp-2.8 -i -b "(batch-unify-image-width \"c:\\users\\test\\Desktop\\temp\\*.jpg\" \"c:\\users\\test\\Desktop\\temp\\output\" 650)" -b "(gimp-quit 0)"
;

(define (batch-unify-image-width filePattern
                                 outputDir
                                 newWidth
        )
        
  (let*
    (
      ; define local variables
      (filelist (cadr (file-glob filePattern 1)))
      
      ; end of local variables
    )
    
    (while (not (null? filelist))
      (let* 
        (
          (fileFullPath (car filelist))
          (image (car (gimp-file-load RUN-NONINTERACTIVE fileFullPath "")))
          (drawable (car (gimp-image-get-active-drawable image)))

          (height (car (gimp-image-height image)))
          (width  (car (gimp-image-width image)))
          (newHeight (* (/ newWidth width) height))
          
          (filename (car (reverse (strbreakup fileFullPath "\\"))))
          (outFile (string-append outputDir "\\" filename))
        )

        (gimp-image-scale-full image newWidth newHeight INTERPOLATION-CUBIC)

        (gimp-file-save RUN-NONINTERACTIVE image drawable outFile "")
        (gimp-image-delete image)
        (set! filelist (cdr filelist))
      )
    )
  )
)
