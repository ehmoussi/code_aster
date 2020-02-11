! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

#ifndef ASTERF_MUMPS_H
#define ASTERF_MUMPS_H
!
!    include necessaire a la gestion des instances MUMPS afin de
!    faire le lien, sans erreur, entre l'occurence MUMPS manipulee
!    et la matrice code_aster
!    En plus: stockage des versions MUMPS autorisees
!----------------------------------------------------------------
#   include "smumps_struc.h"
#   include "cmumps_struc.h"
#   include "dmumps_struc.h"
#   include "zmumps_struc.h"

! Les deux versions de MUMPS autorisees (+ leurs pendants consortium)
    character(len=19), parameter :: vmump1="5.1.2"
    character(len=19), parameter :: vmump2="5.1.2consortium"
    character(len=19), parameter :: vmump3="5.2.1"
    character(len=19), parameter :: vmump4="5.2.1consortium"
    integer :: nmxins
    parameter (nmxins=5)        
    character(len=1) :: roucs(nmxins), precs(nmxins)
    character(len=4) :: etams(nmxins)
    character(len=14) :: nonus(nmxins)
    character(len=19) :: nomats(nmxins), nosols(nmxins)
   
    common /mumpsh/ nonus,nomats,nosols,etams,roucs,precs

    type (smumps_struc) , target :: smps(nmxins)
    type (cmumps_struc) , target :: cmps(nmxins)
    type (dmumps_struc) , target :: dmps(nmxins)
    type (zmumps_struc) , target :: zmps(nmxins)

    common /mumpss/ smps
    common /mumpsc/ cmps
    common /mumpsd/ dmps
    common /mumpsz/ zmps
!----------------------------------------------------------------
#endif
