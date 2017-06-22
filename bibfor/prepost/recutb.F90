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

subroutine recutb(ik1d, nomgrn, tabrev, tabmdb, tabthr)
!
    implicit none
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: ik1d
    character(len=8) :: tabrev, tabmdb, tabthr
    character(len=32) :: nomgrn
! --- BUT : RECUPERATION DES TABLES MECANIQUES, THERMIQUE ET -----------
! ------- : DU GROUPE DE NOEUDS CONSIDERES -----------------------------
! ======================================================================
! IN  : IK1D   : NUMERO D'OCCURENCE ------------------------------------
! OUT : NOMGRN : NOM DU GROUPE DE NOEUDS -------------------------------
! --- : TABREV : TABLE MECANIQUE DU REVETEMENT -------------------------
! --- : TABMDB : TABLE MECANIQUE DU METAL DE BASE ----------------------
! --- : TABTHR : TABLE THERMIQUE ---------------------------------------
! ======================================================================
    integer :: ibid, irev
    character(len=8) :: motfac
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES TABLES ASSOCIEES A K1D POUR L'ITERATION COURANTE-
! ======================================================================
    motfac = 'K1D'
    call getvid(motfac, 'TABL_MECA_REV', iocc=ik1d, scal=tabrev, nbret=irev)
    call getvid(motfac, 'TABL_MECA_MDB', iocc=ik1d, scal=tabmdb, nbret=ibid)
    call getvid(motfac, 'TABL_THER', iocc=ik1d, scal=tabthr, nbret=ibid)
    call getvtx(motfac, 'INTITULE', iocc=ik1d, scal=nomgrn, nbret=ibid)
    if(irev.eq.0) tabrev=tabmdb
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
