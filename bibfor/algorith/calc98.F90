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

subroutine calc98(nomres, mailla, numddl)
    implicit none
!
!***********************************************************************
!    P. RICHARD                                     DATE 09/07/91
!-----------------------------------------------------------------------
!  BUT: ROUTINE DE CALCUL DE BASE MODALE
!
!    BASE MODALE DE TYPE MIXTE CRAIG-BAMPTON MAC-NEAL OU INCONNUE
!
!
!
!
#include "jeveux.h"
#include "asterfort/crlidd.h"
#include "asterfort/ddlact.h"
#include "asterfort/defint.h"
#include "asterfort/gesdef.h"
    character(len=8) :: nomres, mailla
    character(len=19) :: numddl
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!---------  RECUPERATION DES NOEUDS D'INTERFACE       ------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call defint(mailla, nomres)
!
!-------------CREATION TABLEAU DESCRIPTION DES DEFORMES ----------------
!           ET MODIFICATION NUMEROTATION NOEUDS INTERFACES
!
    call crlidd(nomres, mailla)
!
!---------------PRISE EN COMPTE DES MASQUES DE DDL AUX NOEUDS-----------
!             ET DETERMINATION DU NOMBRE DE MODES ET DEFORMEES
!
    call gesdef(nomres, numddl)
!
!
!-----------------DETERMINATION DES DDL INTERFACE ACTIFS FINAUX---------
!
!
    call ddlact(nomres, numddl)
!
end subroutine
