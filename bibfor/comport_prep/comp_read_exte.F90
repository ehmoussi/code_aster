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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_read_exte(rela_comp   , keywf         , i_comp       ,&
                          l_umat      , l_mfront_proto, l_mfront_offi,&
                          libr_name   , subr_name     , nb_vari_umat)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/mfront_get_libname.h"
#include "asterfort/mfront_get_function.h"
!
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: keywf
integer, intent(in) :: i_comp
aster_logical, intent(in) :: l_umat
aster_logical, intent(in) :: l_mfront_proto
aster_logical, intent(in) :: l_mfront_offi
character(len=255), intent(out) :: libr_name
character(len=255), intent(out) :: subr_name
integer, intent(out) :: nb_vari_umat
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get parameters for external programs (MFRONT/UMAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_comp        : RELATION comportment
! In  keywf            : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! In  l_umat           : .true. if UMAT
! In  l_mfront_proto   : .true. if MFront prototype
! In  l_mfront_offi    : .true. if MFront official
! Out libr_name        : name of library if UMAT or MFront
! Out subr_name        : name of comportement in library if UMAT or MFront
! Out nb_vari_umat     : number of internal variables for UMAT
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: saux08
    aster_logical :: l_kit_thm = .false._1
    integer :: scali, nbret
!
! --------------------------------------------------------------------------------------------------
!
    libr_name    = ' '
    subr_name    = ' '
    nb_vari_umat = 0
!
! - Get parameters
!
    if (l_mfront_offi) then
        ASSERT(.not. l_kit_thm)
        call mfront_get_libname(libr_name)
        call mfront_get_function(rela_comp, subr_name)
    elseif (l_mfront_proto) then
        if (i_comp .ne. 0) then
            call getvis(keywf, 'UNITE_LIBRAIRIE'  , iocc = i_comp, scal = scali, nbret = nbret)
            if (nbret .eq. 0) then
                call getvtx(keywf, 'LIBRAIRIE'  , iocc = i_comp, scal = libr_name)
            else
                call codent(scali, 'G', saux08)
                libr_name = 'fort.'//saux08
            endif
            call getvtx(keywf, 'NOM_ROUTINE', iocc = i_comp, scal = subr_name)
        endif
    elseif (l_umat) then
        if (i_comp .ne. 0) then
            call getvtx(keywf, 'LIBRAIRIE'  , iocc = i_comp, scal = libr_name)
            call getvtx(keywf, 'NOM_ROUTINE', iocc = i_comp, scal = subr_name)
            call getvis(keywf, 'NB_VARI'    , iocc = i_comp, scal = nb_vari_umat)
        endif
    endif
!
end subroutine
