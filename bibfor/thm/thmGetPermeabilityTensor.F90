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
!
subroutine thmGetPermeabilityTensor(ndim , angl_naut, j_mater, phi, endo,&
                                    tperm)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/tpermh.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: ndim
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: phi, endo
real(kind=8), intent(out) :: tperm(ndim, ndim)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get permeability tensor
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  j_mater          : coded material address
! In  phi              : porosity
! In  endo             : damage
! Out tperm            : permeability tensor
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 4
    integer :: aniso
    integer :: icodre(nb_para)
    real(kind=8) :: para_vale(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/'PERM_IN ', 'PERMIN_L',&
                                                           'PERMIN_N', 'PERMIN_T'/)
!
! --------------------------------------------------------------------------------------------------
!
    tperm(1:ndim,1:ndim) = 0.d0
    aniso                = 0
    para_vale(:)         = 0.d0
!
! - Read parameters (intrinsic permeability)
!
    para_vale(1)         = 1.d0
    if ( (ds_thm%ds_behaviour%rela_hydr .eq. 'HYDR_UTIL') .or.&
         (ds_thm%ds_behaviour%rela_hydr .eq. 'HYDR_VGM')  .or.&
         (ds_thm%ds_behaviour%rela_hydr .eq. 'HYDR_VGC')) then
        call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                    1      , 'PORO'   , [phi]      ,&
                    1      , para_name, para_vale  ,&
                    icodre , 0        , nan='NON')
        if (icodre(1) .eq. 1) then
! --------- Anisotropic
            call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                        1      , 'PORO'      , [phi]       ,&
                        1      , para_name(3), para_vale(3),&
                        icodre , 0           , nan='NON')
            if (icodre(1) .eq. 0) then
                aniso = 1
                call rcvala(j_mater, ' '          , 'THM_DIFFU' ,&
                            1      , 'PORO'       , [phi]       ,&
                            2      ,  para_name(2), para_vale(2),&
                            icodre , 0            , nan='NON')
            else
                aniso = 2
                call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                            1      , 'PORO'      , [phi]       ,&
                            1      , para_name(2), para_vale(2),&
                            icodre , 0           , nan='NON')
                call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                            1      , 'PORO'      , [phi]       ,&
                            1      , para_name(4), para_vale(4),&
                            icodre , 0           , nan='NON')
            endif
        else if (icodre(1) .eq. 0) then
! --------- Isotropic
            aniso = 0
        endif
    else if (ds_thm%ds_behaviour%rela_hydr .eq. 'HYDR_ENDO') then
        if ((ds_thm%ds_behaviour%rela_meca .eq. 'MAZARS') .or.&
            (ds_thm%ds_behaviour%rela_meca .eq. 'ENDO_ISOT_BETON')) then
            aniso = 0
            call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                        1      , 'ENDO'      , [endo]      ,&
                        1      , ['PERM_END'], para_vale(1),&
                        icodre , 1)
            call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                        1      , 'ENDO'      , [endo]      ,&
                        1      , ['PERM_END'], para_vale(2),&
                        icodre , 1)
            call rcvala(j_mater, ' '         , 'THM_DIFFU' ,&
                        1      , 'ENDO'      , [endo]      ,&
                        1      , ['PERM_END'], para_vale(3),&
                        icodre , 1)
        else
            call utmess('F', 'THM1_43', nk=2,&
                        valk=[ds_thm%ds_behaviour%rela_hydr,ds_thm%ds_behaviour%rela_meca])
        endif
    else
        ASSERT(.false.)
    endif
!
! - Compute permeability tensor
!
    call tpermh(ndim , angl_naut, aniso, para_vale,&
                tperm)  
!
end subroutine
