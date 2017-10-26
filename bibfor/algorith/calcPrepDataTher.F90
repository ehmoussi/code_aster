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
subroutine calcPrepDataTher(model        , temp_prev     , incr_temp   ,&
                            time_curr    , deltat        , theta       , khi,&
                            time         , temp_curr     ,&
                            ve_charther  , me_mtanther   , ve_dirichlet,&
                            ve_evolther_l, ve_evolther_nl, ve_resither)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mvnume.h"
#include "asterfort/gcncon.h"
#include "asterfort/dismoi.h"
#include "asterfort/mecact.h"
#include "asterc/r8vide.h"
!
character(len=24), intent(in) :: model
character(len=19), intent(in) :: temp_prev, incr_temp 
real(kind=8), intent(in) :: time_curr, deltat, theta, khi
character(len=24), intent(out) :: time
character(len=19), intent(out) :: temp_curr
character(len=24), intent(out) :: ve_charther
character(len=24), intent(out) :: me_mtanther
character(len=24), intent(out) :: ve_evolther_l, ve_evolther_nl
character(len=24), intent(out) :: ve_resither
character(len=*), intent(out) :: ve_dirichlet
!
! --------------------------------------------------------------------------------------------------
!
! Command CALCUL
!
! Prepare data for thermics
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  temp_prev        : temperature at beginning of step
! In  incr_temp        : increment of temperature
! In  time_curr        : current time  
! In  deltat           : increment of time
! In  theta            : parameter for theta-scheme
! In  khi              : parameter
! Out time             : name of field for time parameters
! Out temp_curr        : temperature at end of step
! Out ve_charther      : name of elementary for loads vector
! Out me_mtanther      : name of elementary for tangent matrix
! Out ve_evolther_l    : name of elementary for linear transient vector
! Out ve_evolther_nl   : name of elementary for non-linear transient vector
! Out ve_resither      : name of elementary for residual vector
! Out ve_dirichlet     : name of elementary for reaction (Lagrange) vector
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tpsthe(6)
    character(len=19) :: ligrmo
    character(len=8), parameter :: nomcmp(6) = (/'INST    ','DELTAT  ',&
                                                 'THETA   ','KHI     ',&
                                                 'R       ','RHO     '/)
!
! --------------------------------------------------------------------------------------------------
!
    temp_curr = '&&OP0026.TEMPPLU'
    time      = '&&OP0026.CHTPS'
!
! - Get LIGREL
!
    call dismoi('NOM_LIGREL', model, 'MODELE', repk=ligrmo)
!
! - Compute current temperature
!
    call mvnume(temp_prev, incr_temp, temp_curr)
!
! - Datastructures name (automatic génération)
!
    call gcncon('_', ve_charther)
    call gcncon('_', ve_dirichlet)
    call gcncon('_', me_mtanther)
    call gcncon('_', ve_evolther_l)
    call gcncon('_', ve_evolther_nl)
    call gcncon('_', ve_resither)
!
! - Create CARTE for time
! 
    tpsthe(1) = time_curr
    tpsthe(2) = deltat
    tpsthe(3) = theta
    tpsthe(4) = khi
    tpsthe(5) = r8vide()
    tpsthe(6) = r8vide()
    call mecact('V', time, 'MODELE', ligrmo, 'INST_R',&
                ncmp=6, lnomcmp=nomcmp, vr=tpsthe)
!
end subroutine
