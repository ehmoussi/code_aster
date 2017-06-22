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

subroutine cfgeom(iter_newt, mesh     , ds_measure, ds_contact,&
                  disp_curr, time_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfappa.h"
#include "asterfort/cfimp4.h"
#include "asterfort/cfsvmu.h"
#include "asterfort/geomco.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/reajeu.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: iter_newt
    character(len=8), intent(in) :: mesh
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_Contact), intent(inout) :: ds_contact
    character(len=19), intent(in) :: disp_curr
    real(kind=8), intent(in) :: time_curr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Pairing
!
! --------------------------------------------------------------------------------------------------
!
! In  iter_newt        : index of current Newton iteration
! In  mesh             : name of mesh
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_contact       : datastructure for contact management
! In  disp_curr        : current displacements
! In  time_curr        : current time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_pair
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
!
! - Is pairing ?
!
    l_pair      = ds_contact%l_pair
!
! - Save before pairing
!
    if (l_pair) then
        call cfsvmu(ds_contact, .false._1)
    endif
!
! - Print
!
    if (niv .ge. 2) then
        if (l_pair) then
            write (ifm,*) '<CONTACT> ... REACTUALISATION DE L''APPARIEMENT'
        else
            write (ifm,*) '<CONTACT> ... PAS DE REACTUALISATION DE L''APPARIEMENT'
        endif
    endif
!
! - Pairing or not pairing ?
!
    if (l_pair) then
!
        call nmtime(ds_measure, 'Init'  , 'Cont_Geom')
        call nmtime(ds_measure, 'Launch', 'Cont_Geom')
!
! ----- Update geometry
!
        call geomco(mesh, ds_contact, disp_curr)
!
! ----- Pairing
!
        call cfappa(mesh, ds_contact, time_curr)
        call nmtime(ds_measure, 'Stop', 'Cont_Geom')
        call nmrinc(ds_measure, 'Cont_Geom')
!
    else
!
! ----- Update gaps (for step cut)
!
        if (iter_newt .eq. 0) then
            call reajeu(ds_contact)
        endif
    endif
!
! - Debug print
!
    if (niv .ge. 2) then
        call cfimp4(ds_contact, mesh, ifm)
    endif
!
! - Print
!
    if (niv .ge. 2) then
        if (l_pair) then
            write (ifm,*) '<CONTACT> ... FIN DE REACTUALISATION DE L''APPARIEMENT'
        endif
    endif
!
end subroutine
