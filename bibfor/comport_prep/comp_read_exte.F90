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

subroutine comp_read_exte(rela_comp   , kit_comp      ,&
                          l_umat      , l_mfront_proto, l_mfront_offi,&
                          libr_name   , subr_name     ,&
                          keywordfact_, i_comp_       , nb_vari_umat_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/mfront_get_libname.h"
#include "asterfort/mfront_get_function.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: rela_comp
    character(len=16), intent(in) :: kit_comp(4)
    aster_logical, intent(out) :: l_umat
    aster_logical, intent(out) :: l_mfront_proto
    aster_logical, intent(out) :: l_mfront_offi
    character(len=255), intent(out) :: libr_name
    character(len=255), intent(out) :: subr_name
    character(len=16), optional, intent(in) :: keywordfact_
    integer, optional, intent(in) :: i_comp_
    integer, optional, intent(out) :: nb_vari_umat_
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
! In  kit_comp         : KIT comportment
! Out l_umat           : .true. if UMAT
! Out l_mfront_proto   : .true. if MFront prototyp
! Out l_mfront_offi    : .true. if MFront official
! Out libr_name        : name of library if UMAT or MFront
! Out subr_name        : name of comportement in library if UMAT or MFront
! In  keywordfact      : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! Out nb_vari_umat     : number of internal variables for UMAT
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: saux08
    character(len=16) :: rela_comp_ask
    aster_logical :: l_kit_thm = .false._1
    integer :: nb_vari_umat, scali, nbret
!
! --------------------------------------------------------------------------------------------------
!
    l_umat         = .false._1
    l_mfront_proto = .false._1
    l_mfront_offi  = .false._1
    libr_name      = ' '
    subr_name      = ' '
    nb_vari_umat   = 0
!
! - Select comportement
!
    call comp_meca_l(rela_comp, 'KIT_THM', l_kit_thm)
    if (l_kit_thm) then
        rela_comp_ask = kit_comp(4)
    else
        rela_comp_ask = rela_comp
    endif
!
! - Detect type
!
    call comp_meca_l(rela_comp_ask, 'UMAT'        , l_umat)
    call comp_meca_l(rela_comp_ask, 'MFRONT_OFFI' , l_mfront_offi)
    call comp_meca_l(rela_comp_ask, 'MFRONT_PROTO', l_mfront_proto)
!
! - Get parameters
!
    if (l_mfront_offi) then
        ASSERT(.not.l_kit_thm)
        call mfront_get_libname(libr_name)
        call mfront_get_function(rela_comp_ask, subr_name)
    elseif (l_mfront_proto) then
        if (present(keywordfact_)) then
            call getvis(keywordfact_, 'UNITE_LIBRAIRIE'  , iocc = i_comp_,&
                        scal = scali, nbret = nbret)
            if( nbret.ne.0 ) then
                call codent(scali, 'G', saux08)
                libr_name = 'fort.'//saux08
            else
                call getvtx(keywordfact_, 'LIBRAIRIE'  , iocc = i_comp_, scal = libr_name)
            endif
            call getvtx(keywordfact_, 'NOM_ROUTINE', iocc = i_comp_, scal = subr_name)
        endif
    elseif (l_umat) then
        if (present(keywordfact_)) then
            call getvtx(keywordfact_, 'LIBRAIRIE'  , iocc = i_comp_, scal = libr_name)
            call getvtx(keywordfact_, 'NOM_ROUTINE', iocc = i_comp_, scal = subr_name)
            call getvis(keywordfact_, 'NB_VARI'    , iocc = i_comp_, scal = nb_vari_umat)
        endif
    endif
!
! - Save
!
    if (present(nb_vari_umat_)) then
        nb_vari_umat_ = nb_vari_umat
    endif
!
end subroutine
