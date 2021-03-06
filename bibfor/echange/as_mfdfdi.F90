! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine as_mfdfdi(fid, ind, cha, type, comp,&
                     unit, nseqca, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfdfdi.h"
    character(len=*) :: cha, comp, unit
    med_idt :: fid
    aster_int :: ind, type, cret, nseqca
    character(len=64) :: nommai
    character(len=80) :: unidt
!
!     UNITE DU PAS DE TEMPS EST UN GRANDEUR PAS UTILISEE DANS ASTER
!     DE MEME QUE LE MAILLAGE QUI EST RELU AVANT LIRE_RESU
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fidm
    med_int :: ind4, type4, cret4, nseqc4, lmai4
    fidm = to_med_idt(fid)
    ind4 = ind
    call mfdfdi(fidm, ind4, cha, nommai, lmai4,&
                type4, comp, unit, unidt, nseqc4,&
                cret4)
    type = type4
    cret = cret4
    nseqca = nseqc4
#else
    call mfdfdi(fid, ind, cha, nommai, lmail,&
                type, comp, unit, unidt, nseqca,&
                cret)
#endif
!
#endif
end subroutine
