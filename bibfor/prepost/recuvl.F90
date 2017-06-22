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

subroutine recuvl(nbval, tbinst, nbval2, tbinth, norev,&
                  tbscrv, nomdb, tbscmb)
!
    implicit none
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/tbexv1.h"
    integer :: nbval, nbval2, norev, nomdb
    character(len=19) :: tbinst, tbinth, tbscrv, tbscmb
! --- BUT : RECUPERATION DES TABLES MECANIQUES, THERMIQUE ET -----------
! ------- : DU GROUPE DE NOEUDS CONSIDERES -----------------------------
! ======================================================================
! OUT : NBVAL  : NOMBRE D'INSTANT DE CALCUL MECANIQUE ------------------
! --- : TBINST : VECTEUR DES INSTANTS DE CALCUL MECANIQUE --------------
! --- : NBVAL2 : NOMBRE D'INSTANT DE CALCUL THERMIQUE ------------------
! --- : TBINTH : VECTEUR DES INSTANTS DE CALCUL THERMIQUE --------------
! --- : NOREV  : NOMBRE DE NOEUDS COTE REVETEMENT ----------------------
! --- : TBSCRV : VECTEUR DES ABSCISSES CURVILIGNES COTE REVETEMENT -----
! --- : NOMDB  : NOMBRE DE NOEUDS COTE METAL DE BASE -------------------
! --- : TBSCMB : VECTEUR DES ABSCISSES CURVILIGNES COTE METAL DE BASE --
! ======================================================================
    integer :: ibid,irev
    character(len=8) :: motfac, k8b, tabrev, tabmdb, tabthr
! ======================================================================
    call jemarq()
! ======================================================================
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
    motfac = 'K1D'
! ======================================================================
! --- RECUPERATION DES TABLES ASSOCIEES A K1D POUR L'ITERATION COURANTE-
! ======================================================================
    call getvid(motfac, 'TABL_MECA_REV', iocc=1, scal=tabrev, nbret=irev)
    call getvid(motfac, 'TABL_MECA_MDB', iocc=1, scal=tabmdb, nbret=ibid)
    call getvid(motfac, 'TABL_THER', iocc=1, scal=tabthr, nbret=ibid)
    if(irev.eq.0) then
      tabrev=tabmdb
    endif
! ======================================================================
! --- RECUPERATION DES LISTES D'INSTANT --------------------------------
! ======================================================================
    call tbexv1(tabrev, 'INST', tbinst, 'V', nbval,&
                k8b)
    call tbexv1(tabthr, 'INST', tbinth, 'V', nbval2,&
                k8b)
! ======================================================================
! --- RECUPERATION DE LA LISTE DES ABSCISSES CURVILIGNES ---------------
! --- COTE REVETEMENT --------------------------------------------------
! ======================================================================
    call tbexv1(tabrev, 'ABSC_CURV', tbscrv, 'V', norev,&
                k8b)
! ======================================================================
! --- RECUPERATION DE LA LISTE DES ABSCISSES CURVILIGNES ---------------
! --- COTE METAL DE BASE -----------------------------------------------
! ======================================================================
    call tbexv1(tabmdb, 'ABSC_CURV', tbscmb, 'V', nomdb,&
                k8b)
! ======================================================================
! --- DESTRUCTION DES TABLES INUTILES ----------------------------------
! ======================================================================
    call jedetr(tabrev)
    call jedetr(tabmdb)
    call jedetr(tabthr)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
