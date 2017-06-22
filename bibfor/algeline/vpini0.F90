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

subroutine vpini0(compex, modes, typcon, solveu, eigsol, matpsc, matopa, veclag,&
                  vecblo, vecrig, vecrer, vecrei, vecrek, vecvp)

! INITIALISATIONS LIEES A L'OPERATEUR MODE_ITER_SIMULT.
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none

#include "asterc/getres.h"
#include "asterfort/onerrf.h"

!
! --- INPUT
! None
!
! --- OUTPUT
!
    character(len=8)  , intent(out) :: modes
    character(len=16) , intent(out) :: compex, typcon
    character(len=19) , intent(out) :: matpsc, matopa, solveu, eigsol
    character(len=24) , intent(out) :: veclag, vecblo, vecrig, vecrer, vecrei, vecrek, vecvp
!
! --- INPUT/OUTPUT
! None
!
! --- VARIABLES LOCALES
!
    integer           :: lenout
    character(len=16) :: nomcmd
!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!

! --- INITS. OBJETS JEVEUX PROPRES A CET OPERATEUR
    solveu='&&OP0045.SOLVEUR'
    eigsol='&&OP0045.EIGSOL'
!
    matpsc = '&&OP0045.DYN_FAC_R '
    matopa = '&&OP0045.DYN_FAC_C '
!
    veclag = '&&OP0045.POSITION.DDL'
    vecblo = '&&OP0045.DDL.BLOQ.CINE'
    vecrig = '&&OP0045.MODE.RIGID'
!
    vecrer = '&&OP0045.RESU_'
    vecrei = '&&OP0045.RESU_I'
    vecrek = '&&OP0045.RESU_K'
    vecvp  = '&&OP0045.VECTEUR_PROPRE'

! -- ON STOCKE LE COMPORTEMENT EN CAS D'ERREUR : COMPEX
    compex=''
    call onerrf(' ', compex, lenout)

! -- RECUPERATION DU RESULTAT
    modes=''
    typcon=''
    nomcmd=''
    call getres(modes, typcon, nomcmd)
!
!     FIN DE VPINI0
!
end subroutine
