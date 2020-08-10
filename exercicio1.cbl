      $set sourceformat"free"

      *>Divisão de identificação do programa
       Identification Division.
       Program-id. "exercicio1".
       Author. "Jéssica C.Del'agnolo".
       Installation. "PC".
       Date-written. 08/07/2020.
       Date-compiled. 08/07/2020.



      *>Divisão para configuração do ambiente
       Environment Division.
       Configuration Section.
           special-names. decimal-point is comma.

      *>----Declaração dos recursos externos
       Input-output Section.
       File-control.

           select arqTemp assign to "arqTemp.txt"
           organization is line sequential
           access mode is sequential
           lock mode automatic
           file status is ws-fs-arqTemp.

       I-O-Control.


      *>Declaração de variáveis
       Data Division.

      *>----Variaveis de arquivos
       File Section.
       fd arqTemp.
       01 fd-temp.
          05 fd-dia                                pic  9(07).
          05 fd-temperatura                        pic s9(02)v99.


      *>----Variaveis de trabalho
       Working-storage Section.

       77 ws-fs-arqTemp                            pic 9(02).

       01 ws-temp occurs 30.
          05 ws-dia                                pic x(10).
          05 ws-temperatura                        pic s9(02)v99.

       77 ws-ind                                   pic 9(02).
       77 ws-media_temp                            pic s9(02)v99.
       77 ws-media                                 pic s9(02)v99.
       77 ws-escolhe                               pic 9(02).
       77 ws-menu                                  pic 9(01).

       77  ws-estado-arqTemp                       pic  x(01).
           88  arqTemp-open                        value "o".
           88  arqTemp-closed                      value "c".




      *>----Variaveis para comunicação entre programas
       Linkage Section.

      *>----Declaração de tela
       Screen Section.


      *>Declaração do corpo do programa
       Procedure Division.

           perform inicializa.
           perform guarda_temp.
           perform calculo.
           perform exibe.
           perform finaliza.

       inicializa section.


           .
       inicializa-exit.
           exit.

       *>=======================================================================
       *>  Guardar temperatura no arquivo
       *>=======================================================================

       guarda_temp section.

           open extend  arqTemp
           if ws-fs-arqTemp = 0
           or ws-fs-arqTemp = 05 then
               set arqTemp-open to true
           else
               display "File Status ao abrir input arquivo: " ws-fs-arqTemp
           end-if


           move 1 to ws-ind

           perform 30 times
               move ws-ind to ws-dia(ws-ind)
               display "Insira a Temperatura do Dia " ws-ind ":"
               accept ws-temperatura(ws-ind)

               add 1 to ws-ind

      *> -------------  Salvar dados no arquivo
               move  ws-temp(ws-ind)  to  fd-temp

               write fd-temp *> grava os dados no arquivo
               if ws-fs-arqTemp <> 0 then
                   display "File Status ao escrever arquivo: " ws-fs-arqTemp
               end-if
      *>--------------

           end-perform

           if arqTemp-open then
               close arqTemp    *> fecha arquivo
               if ws-fs-arqTemp = 0 then
                   set arqTemp-closed to true
               else
                   display "File Status ao fechar arquivo: " ws-fs-arqTemp
               end-if
           end-if



           .
       guarda_temp-exit.
           exit.

       *>=======================================================================
       *>  Exibe data escolhida
       *>=======================================================================

       exibe section.

           display erase

           move 1 to ws-menu
           move 0 to ws-escolhe

           perform until ws-menu <> "1"
               display "Indique o Numero do Dia que Deseja Exibir:"
               accept ws-escolhe

               display " "

               display ws-temperatura(ws-escolhe)

               display " "


               if ws-temperatura(ws-escolhe) > ws-media then
                   display " A Temperatura do Dia Solicitado Estava Acima da Media."
               end-if

               if ws-temperatura(ws-escolhe) < ws-media then
                   display " A Temperatura do Dia Solicitado Estava Abaixo da Media."
               end-if

               if ws-temperatura(ws-escolhe) = ws-media then
                   display " A Temperatura do Dia Solicitado Estava Igual a Media."
               end-if

               display " "

               display "Deseja Consultar Outro dia?"
               display "1 - Sim."
               display "2 - Nao."
               accept ws-menu

           end-perform


           .
       exibe-exit.
           exit.

       *>=======================================================================
       *>  Calcula a média de temperatura
       *>=======================================================================

       calculo section.

           move 1 to ws-ind
           move 0 to ws-media_temp

           perform 30 times
               add ws-temperatura(ws-ind) to ws-media_temp
               add 1 to ws-ind
           end-perform

           divide ws-media_temp by 30 giving ws-media

           .
       calculo-exit.
           exit.

       finaliza section.

           display "Programa Encerrado."
           .
       finaliza-exit.
           exit.



           Stop Run.










