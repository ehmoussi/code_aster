! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine ibbase(ier, fichdf)
    implicit none
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterc/loisem.h"
#include "asterc/mofiem.h"
#include "asterc/rmfile.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/jeinif.h"
#include "asterfort/jelibf.h"
#include "asterfort/jelihd.h"
#include "asterfort/utmess.h"
#include "asterfort/utremt.h"
    integer :: ier
    character(len=*) :: fichdf
!     ALLOCATION ET OUVERTURE DES BASES DE DONNEES
!     ------------------------------------------------------------------
! IN  COMMAND : CH* : NOM DE LA COMMANDE APPELANTE  (DEBUT OU POURSUITE)
! OUT IER     : IS  : CODE RETOUR D'EXECUTION
!         0 ==> PAS DE PROBLEME
!         1 ==> PROBLEME D'ALLOCATION DES BASES DE DONNEES
!         2 ==> PROBLEME D'OUVERTURE DES BASES DE DONNEES
!     ------------------------------------------------------------------
!
!     --- VARIABLES LOCALES --------------------------------------------
!     NOM DES BASES DE DONNEES AUTORISEES
!     REMARQUE :  UN DDNAME OU SHORT NAME NE PEUT EXCEDER 7 CARACTERES
!     ------------------------------------------------------------------
!
    character(len=16) :: motfac, nomres, concep, nomcmd
!
!     --- VARIABLES LOCALES --------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, ibase, ideb, indbas, indcas, ltt
    integer :: mxbase, mxcas, nb, nbbase, n
!-----------------------------------------------------------------------
    parameter   ( mxbase = 2 , n = 5 )
    integer :: banbbl(mxbase), balgbl(mxbase), balgre(mxbase)
!
!     --- VALEURS PAR DEFAUTS DES BASES --------------------------------
    integer :: presba(mxbase)
    character(len=16) :: nomba (mxbase), nom
    character(len=16) :: stin (mxbase), stout (mxbase)
    character(len=16) :: cas
    character(len=32) :: titrba(mxbase)
!
!     --- VALEURS PAR DEFAUTS DES CAS ----------------------------------
    parameter   ( mxcas  = 3 )
    character(len=16) :: casca (mxcas)
    character(len=24) :: valk(3)
    integer :: nbblca(mxbase, mxcas), lgblca(mxbase, mxcas)
    integer :: lgreca(mxbase, mxcas)
    integer :: vali(2), info
!
    integer :: lfic, mfic
    common /fenvje/  lfic(n),mfic
!
    data      nomba  /'GLOBALE '   , 'VOLATILE'   /
    data      presba /    0        ,     0        /
    data      titrba /'BASEGLOBALE', 'BASEVOLATILE'/
    data      stin   /'........'   , 'DEBUT   '    /
    data      stout  /'SAUVE   '   , 'SAUVE   '    /
!
!
    data casca  /'PETIT           ','MOYEN           ','GROS            '/
!
!     TAILLE(GLOBALE)        PETIT   MOYEN      GROS
    data&
     &  (nbblca(1,i),i=1,3)/   0      , 0     ,    0        /,&
     &  (lgblca(1,i),i=1,3)/ 100   ,  100     ,  100        /,&
     &  (lgreca(1,i),i=1,3)/2000   , 4000     , 6000        /
!
!     TAILLE(VOLATILE)       PETIT   MOYEN      GROS
    data&
     &  (nbblca(2,i),i=1,3)/   0   ,    0     ,    0         /,&
     &  (lgblca(2,i),i=1,3)/ 100   ,  100     ,  100         /,&
     &  (lgreca(2,i),i=1,3)/2000   , 2000     , 2000         /
!
!     ------------------------------------------------------------------
!
!     INITIALISATION DU CODE RETOUR
    ier = 0
!
!     --- RECUPERATION DU NOM DE LA COMMANDE UTILISATEUR ---
    call getres(nomres, concep, nomcmd)
    stin(1) = nomcmd
!
    indcas = 1
    do indbas = 1, mxbase
        banbbl(indbas) = nbblca(indbas,indcas)
        balgbl(indbas) = lgblca(indbas,indcas)
        balgre(indbas) = lgreca(indbas,indcas)
    end do
!
!     --- NOMBRE DE BASES SPECIFIEES PAR L'UTILISATEUR -----------------
    motfac = 'BASE'
    call getfac(motfac, nbbase)
!
    do ibase = 1, nbbase
!
!        --- MOT CLE "FICHIER" ANCIENNEMENT "NOM" ---------------------
        call getvtx(motfac, 'FICHIER', iocc=ibase, scal=nom, nbret=nb)
        call utremt(nom, nomba, mxbase, indbas)
        if (indbas .eq. 0) then
            indbas = 1
            ier = ier + 1
            vali (1) = mxbase
            valk (1) = nom
            valk (2) = nomba(1)
            valk (3) = nomba(2)
            call utmess('E', 'SUPERVIS_81', nk=3, valk=valk, si=vali(1))
        else
            if (presba(indbas) .ne. 0) then
                ier = ier + 1
                call utmess('E', 'SUPERVIS_13', sk=nom)
            else
                presba(indbas) = 1
            endif
        endif
!
!        --- MOT CLE "CAS" ---------------------------------------------
!
        call getvtx(motfac, 'CAS', iocc=ibase, scal=cas, nbret=nb)
        if (nb .gt. 0) then
            call utremt(cas, casca, mxcas, indcas)
            if (indcas .eq. 0) then
                indcas = 1
                ier = ier + 1
                vali (1)= mxcas
                valk (1) = cas
                valk (2) = casca(1)
                valk (3) = casca(2)
                call utmess('E', 'SUPERVIS_82', nk=3, valk=valk, si=vali(1))
            endif
        endif
!
!        ---NOMBRE DE BLOC D'ENREGISTREMENT ----------------------------
        banbbl(indbas) = nbblca(indbas,indcas)
        call getvis(motfac, 'NMAX_ENRE', iocc=ibase, scal=banbbl(indbas), nbret=nb)
!
!        --- LONGUEUR D'UN BLOC D'ENREGISTREMENT -----------------------
        balgbl(indbas) = lgblca(indbas,indcas)
        call getvis(motfac, 'LONG_ENRE', iocc=ibase, scal=balgbl(indbas), nbret=nb)

!       valeur par defaut issue du common
        call getvis(motfac, 'TAILLE', iocc=ibase, scal=lfic(indbas), nbret=nb)
!
        ltt = banbbl(indbas)*balgbl(indbas)*loisem()
        if (ltt .gt. mofiem()) then
            ier = ier + 1
            vali (1) = ltt
            vali (2) = mofiem()
            call utmess('E', 'SUPERVIS_83', ni=2, vali=vali)
        endif
!
!        --- MOT CLE "LONG_REPE" ---------------------------------------
        balgre(indbas) = lgreca(indbas,indcas)
        call getvis(motfac, 'LONG_REPE', iocc=ibase, scal=balgre(indbas), nbret=nb)
!
!        --- MOT CLE "TITRE" -------------------------------------------
        call getvtx(motfac, 'TITRE', iocc=ibase, scal=titrba(indbas), nbret=nb)
!
     end do
!
!
!     --- QUELQUES CONTROLES SUPPLEMENTAIRES SUR LA GLOBALE EN POURSUITE
    if (nomcmd .eq. 'POURSUITE') then
        call utremt('GLOBALE', nomba, mxbase, indbas)
        if (indbas .gt. 0) then
            if (stin(indbas) .ne. 'POURSUITE') then
                ier = ier + 1
                call utmess('E', 'SUPERVIS_14', sk=stin(indbas))
            endif
        endif
    endif
!
!     --- DEFINITION DES UNITES LOGIQUES DES BASES DE DONNEES ---
!
    if (ier .eq. 0) then
!
!        --- DESTRUCTION DE LA BASE TEMPORAIRE VOLATILE ---
        info = 0
        call jelibf('DETRUIT', 'V', info)
!
!        --- RE-DEFINITION DE L'ENVIRONNEMENT SELON DESIRS UTILISATEUR -
!
!        --- INITIALISATION DE CHAQUE BASE ---
        if (fichdf .ne. ' ') then
            call jelihd('GLOBALE ', fichdf, 'G')
!           --- DESTRUCTION DU FICHIER POUR QU'ON NE CONFONDE PAS PLUS
!               TARD AVEC UNE EVENTUELLE BASE HDF EN RESULTAT ---
            info=1
            call rmfile(fichdf, info)
        endif
        ideb = 1
        if (fichdf .ne. ' ') ideb = 2
!
        do 300 ibase = ideb, mxbase
            call jeinif(stin(ibase), stout(ibase), nomba(ibase)(1:8), nomba(ibase)(1:1),&
                        balgre(ibase), banbbl(ibase), balgbl( ibase))
300      continue
    else
!
        call utmess('E', 'SUPERVIS_15')
    endif
!
end subroutine
