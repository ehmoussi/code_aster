! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine nmunil(mesh  , disp_curr, disp_iter, solver    , matr_asse,&
                  cncine, iter_newt, time_curr, ds_contact, nume_dof ,&
                  ctccvg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/algocu.h"
#include "asterfort/algocup.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cuprep.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtdsc3.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=14), intent(in) :: nume_dof
    character(len=19), intent(in) :: disp_curr
    character(len=19), intent(in) :: disp_iter
    character(len=19), intent(in) :: solver
    character(len=19), intent(in) :: matr_asse
    character(len=19), intent(in) :: cncine
    integer, intent(in) :: iter_newt
    real(kind=8), intent(in) :: time_curr
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(out) :: ctccvg
    aster_logical :: l_unil_pena
!
! --------------------------------------------------------------------------------------------------
!
! Unilateral constraint - Solve
!
! Solve
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  disp_curr        : current displacements
! In  disp_iter        : displacement iteration
! In  solver           : datastructure for solver parameters
! In  matr_asse        : matrix
! In  cncine           : void load for kinematic loads
! In  iter_newt        : index of current Newton iteration
! In  time_curr        : current time
! IO  ds_contact       : datastructure for contact management
! Out ctccvg           : output code for contact algorithm
!                        -1 - No solving
!                         0 - OK
!                        +1 - Maximum contact iteration
!                        +2 - Singular contact matrix
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sdcond_matr
    integer :: ldscon, lmat
    integer :: ifm, niv, nb_equa
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> DEBUT DU TRAITEMENT DES CONDITIONS UNILATERALes'
    endif
!
! - Get "contact" matrix
!
    sdcond_matr = ds_contact%sdunil_solv(1:14)//'.MATC'
    call mtdsc3(sdcond_matr)
    call jeveuo(sdcond_matr(1:19)//'.&INT', 'E', ldscon)
!
! - Initializations
!
    ctccvg = -1
!
! - Get matrix descripor
!
    call jeveuo(matr_asse//'.&INT', 'E', lmat)
!
! - Prepare unilateral constraints
!
    l_unil_pena = cfdisl(ds_contact%sdcont_defi, 'UNIL_PENA')
!
    if ((iter_newt.eq.0) .or. l_unil_pena) then
       nb_equa = zi(lmat+2)
       call cuprep(mesh, nb_equa, ds_contact, disp_curr, disp_iter, time_curr)
    endif
!
! - Solve
!
    if (l_unil_pena) then
!   Toujours algorithme de penalisation
!   Arguments à changer
!   A changer dans une version plus aboutie du code
       call algocup(ds_contact, nume_dof, matr_asse)
       ctccvg = 0
!
    else
       call algocu(ds_contact, solver, lmat, ldscon, cncine,&
                disp_iter , ctccvg)
    endif
!
! - Yes for computation
!
    ASSERT(ctccvg.ge.0)
!
end subroutine
