! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine mfront_get_mater_value(BEHinteg ,&
                                  rela_comp, jvariext1, jvariext2,&
                                  fami     , kpg      , ksp, imate, &
                                  nprops   , props)
!
use Behaviour_type
!
implicit none
!
#include "asterc/r8nnem.h"
#include "asterc/mfront_get_mater_prop.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/mat_proto.h"
#include "asterfort/rcvalb.h"
#include "asterfort/metaGetPhase.h"
#include "asterfort/isdeco.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
type(Behaviour_Integ), intent(in) :: BEHinteg
character(len=16), intent(in) :: rela_comp
integer, intent(in) :: jvariext1, jvariext2
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp, imate
integer, intent(inout) :: nprops
real(kind=8), intent(out) :: props(*)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (MFront)
!
! Get material properties
!
! --------------------------------------------------------------------------------------------------
!
! In  BEHinteg         : parameters for integration of behaviour
! In  rela_comp        : RELATION comportment
! In  jvariext1        : first coded integer for external state variable
! In  jvariext2        : second coded integer for external state variable
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! IO  nprops           : number of material properties
! Out props            : values of material properties
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: npropmax = 197
    integer :: codrel(npropmax), nbcoef, i
    character(len=16) :: nomres(npropmax)
    real(kind=8) :: propl(npropmax)
    real(kind=8) :: zalpha
    integer      :: nb_phasis, meta_type
    integer      :: tabcod(60), variextecode(2)
    integer, parameter :: nb_para = 3
    real(kind=8) :: para_vale(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/'X', 'Y', 'Z'/)
!
! --------------------------------------------------------------------------------------------------
!
    tabcod(:) = 0
    variextecode(1) = jvariext1
    variextecode(2) = jvariext2
    call isdeco(variextecode, tabcod, 60)
    nbcoef = 0
!
! - Coordinates of current Gauss point
!
    para_vale = BEHinteg%elga%coorpg
!
! - Get parameters
!
    if (rela_comp .eq. 'MFRONT') then
        call mat_proto(BEHinteg,&
                       fami    , kpg, ksp, '+', imate, rela_comp,&
                       nprops  , props)
    else
! ----- Get the number and the names of the material properties
        call mfront_get_mater_prop(rela_comp, nbcoef, nomres)
        ASSERT(nbcoef <= npropmax)
! ----- Get the properties values (enter under 'rela_comp' in DEFI_MATERIAU)
        props(1:nprops) = r8nnem()
        if (tabcod(ZFERRITE) .eq. 1) then
            meta_type = 1
            nb_phasis = 5
            call metaGetPhase(fami     , '+', kpg, ksp, meta_type,&
                              nb_phasis, zcold_   = zalpha)
            do i = 1, nbcoef
                if (nomres(i)(1:4) .eq. 'meta') then
                    call rcvalb(fami, 1, 1, '+', imate,&
                                ' ', rela_comp, 1, 'META', [zalpha],&
                                1, nomres(i), propl(i), codrel(i), 2)
                else
                    call rcvalb(fami, kpg, ksp, '+', imate, &
                                ' ', rela_comp, 0, ' ', [0.d0], &
                                1, nomres(i), propl(i), codrel(i), 1)
                endif
            enddo
        elseif (tabcod(ZALPHPUR) .eq. 1) then
            meta_type = 2
            nb_phasis = 3
            call utmess('F', 'COMPOR4_24')
        else
            if (BEHinteg%l_varext_geom) then
                call rcvalb(fami, kpg, ksp, '+', imate, &
                            ' ', rela_comp, 0, ' ', [0.d0], &
                            nbcoef, nomres, propl, codrel, 1)
            else
                call rcvalb(fami, kpg, ksp, '+', imate, &
                            ' ', rela_comp, nb_para, para_name, para_vale, &
                            nbcoef, nomres, propl, codrel, 1)
            endif
        endif
! ----- Count the number of properties (but there are all compulsory)
        nprops = 0
        do i = 1, nbcoef
            if (codrel(i) .eq. 0) then
                nprops = nprops+1
                props(nprops) = propl(i)
            endif
        end do
    endif
end
