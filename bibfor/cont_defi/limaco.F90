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

subroutine limaco(sdcont      , keywf , mesh, model, model_ndim,&
                  nb_cont_zone, ligret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/dfc_read_cont.h"
#include "asterfort/dfc_read_disc.h"
#include "asterfort/dfc_read_xfem.h"
#include "asterfort/dfc_read_lac.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    character(len=19), intent(in) :: ligret
    integer, intent(in) :: nb_cont_zone
    integer, intent(in) :: model_ndim
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get elements and nodes of contact, checkings
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  nb_cont_zone     : number of zones of contact
! In  model            : name of model
! In  mesh             : name of mesh
! In  model_ndim       : dimension of model
! In  ligret           : special LIGREL for slaves elements
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cont_form
    character(len=24) :: sdcont_defi
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
    cont_form   = cfdisi(sdcont_defi,'FORMULATION')
!
    if (cont_form .eq. 1) then
        call dfc_read_disc(sdcont      , keywf, mesh, model, model_ndim,&
                           nb_cont_zone)
    elseif (cont_form .eq. 2) then
        call dfc_read_cont(sdcont, keywf       , mesh, model, model_ndim  ,&
                           ligret, nb_cont_zone)
    elseif (cont_form .eq. 3) then
        call dfc_read_xfem(sdcont      , keywf, mesh, model, model_ndim,&
                           nb_cont_zone)
    elseif (cont_form .eq. 5) then
        call dfc_read_lac (sdcont, keywf       , mesh, model, model_ndim  ,&
                           ligret, nb_cont_zone)                      
    else
        ASSERT(.false.)
    endif
!
end subroutine
