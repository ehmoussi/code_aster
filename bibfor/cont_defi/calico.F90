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

subroutine calico(sdcont, mesh, model, model_ndim_, cont_form,&
                  ligret)
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/caraco.h"
#include "asterfort/limaco.h"
#include "asterfort/surfco.h"
#include "asterfort/caramx.h"
#include "asterfort/utmess.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    integer, intent(in) :: model_ndim_
    integer, intent(in) :: cont_form
    character(len=19), intent(in) :: ligret
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Get all informations in command
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  model            : name of model
! In  mesh             : name of mesh
! In  model_ndim_      : dimension of model
! In  cont_form        : formulation of contact
! In  ligret           : name of special LIGREL for slave elements
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_zone, model_ndim
    character(len=16) :: keywf
!
! --------------------------------------------------------------------------------------------------
!
    model_ndim   = 0
    nb_cont_zone = 0
    keywf        = 'ZONE'
!
! - Number of contact zones
!
    call getfac(keywf, nb_cont_zone)
    if (nb_cont_zone .ne. 0) then
!
! ----- Adapt space dimension
!
        if (model_ndim_ .gt. 3) then
            call utmess('A', 'CONTACT_84')
            if (model_ndim_ .eq. 1003) then
                model_ndim = 3
            else if (model_ndim_ .eq. 1002) then
                model_ndim = 2
            else if (model_ndim_ .eq. 23) then
                model_ndim = 2
            else
                ASSERT(.false.)
            endif
        else
            model_ndim = model_ndim_
        endif
!
! ----- Creation of datastructures
!
        call caramx(sdcont, cont_form, nb_cont_zone)
!
! ----- Get parameters of contact
!
        call caraco(sdcont, model, keywf, cont_form, nb_cont_zone)
!
! ----- Get elements and nodes of contact, checkings
!
        call limaco(sdcont      , keywf, mesh, model, model_ndim,&
                    nb_cont_zone, ligret)
!
! ----- Debug print
!
        call surfco(sdcont, mesh)
    endif
!
end subroutine
