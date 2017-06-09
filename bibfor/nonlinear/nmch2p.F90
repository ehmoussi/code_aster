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

subroutine nmch2p(solalg)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterfort/nmcha0.h"
    character(len=19) :: solalg(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! CREATION DES VARIABLES CHAPEAUX - SOLALG
!
! ----------------------------------------------------------------------
!
!
! OUT SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
! ----------------------------------------------------------------------
!
    character(len=19) :: depold, ddepla, depdel, deppr1, deppr2
    character(len=19) :: vitold, dvitla, vitdel, vitpr1, vitpr2
    character(len=19) :: accold, daccla, accdel, accpr1, accpr2
    character(len=19) :: depso1, depso2
!
    data depdel,ddepla    /'&&NMCH2P.DEPDEL','&&NMCH2P.DDEPLA'/
    data depold           /'&&NMCH2P.DEPOLD'/
    data deppr1,deppr2    /'&&NMCH2P.DEPPR1','&&NMCH2P.DEPPR2'/
    data vitdel,dvitla    /'&&NMCH2P.VITDEL','&&NMCH2P.DVITLA'/
    data vitold           /'&&NMCH2P.VITOLD'/
    data vitpr1,vitpr2    /'&&NMCH2P.VITPR1','&&NMCH2P.VITPR2'/
    data accdel,daccla    /'&&NMCH2P.ACCDEL','&&NMCH2P.DACCLA'/
    data accold           /'&&NMCH2P.ACCOLD'/
    data accpr1,accpr2    /'&&NMCH2P.ACCPR1','&&NMCH2P.ACCPR2'/
    data depso1,depso2    /'&&NMCH2P.DEPSO1','&&NMCH2P.DEPSO2'/
!
! ----------------------------------------------------------------------
!
    call nmcha0('SOLALG', 'ALLINI', ' ', solalg)
    call nmcha0('SOLALG', 'DDEPLA', ddepla, solalg)
    call nmcha0('SOLALG', 'DEPDEL', depdel, solalg)
    call nmcha0('SOLALG', 'DEPPR1', deppr1, solalg)
    call nmcha0('SOLALG', 'DEPPR2', deppr2, solalg)
    call nmcha0('SOLALG', 'DEPOLD', depold, solalg)
    call nmcha0('SOLALG', 'DVITLA', dvitla, solalg)
    call nmcha0('SOLALG', 'VITDEL', vitdel, solalg)
    call nmcha0('SOLALG', 'VITPR1', vitpr1, solalg)
    call nmcha0('SOLALG', 'VITPR2', vitpr2, solalg)
    call nmcha0('SOLALG', 'VITOLD', vitold, solalg)
    call nmcha0('SOLALG', 'DACCLA', daccla, solalg)
    call nmcha0('SOLALG', 'ACCDEL', accdel, solalg)
    call nmcha0('SOLALG', 'ACCPR1', accpr1, solalg)
    call nmcha0('SOLALG', 'ACCPR2', accpr2, solalg)
    call nmcha0('SOLALG', 'ACCOLD', accold, solalg)
    call nmcha0('SOLALG', 'DEPSO1', depso1, solalg)
    call nmcha0('SOLALG', 'DEPSO2', depso2, solalg)
!
end subroutine
