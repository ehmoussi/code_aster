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

subroutine locglo(xlocal, sina, cosa, sinb, cosb,&
                  sing, cosg, xgloba)
!
!***********************************************************************
! 01/01/91    G.JACQUART AMV/P61 47 65 49 41
!***********************************************************************
!     FONCTION  : PASSAGE DU REPERE LOCAL AU REPERE GLOBAL
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!        NOM        MODE                    ROLE
!  ________________ ____ ______________________________________________
!                         VARIABLES DU SYSTEME DYNAMIQUE MODAL
!  ________________ ____ ______________________________________________
!    XLOCAL         <--   COORDONNES DANS LE REPERE LOCAL
!    SINA,SINB,SING <--   SINUS DES ANGLES DE ROTATION REP. GLOBAL LOC.
!    COSA,COSB,COSG <--   COSINUS DES ANGLES DE ROTATION REP. GLOB LOC.
!    XGLOBA          -->  COORDONEES DANS LE REPERE GLOBAL
!-----------------------------------------------------------------------
    implicit none
#include "asterfort/rot3di.h"
    real(kind=8) :: xgloba(3), xlocal(3)
!
!-----------------------------------------------------------------------
    real(kind=8) :: cosa, cosb, cosg, sina, sinb, sing
!-----------------------------------------------------------------------
    call rot3di(xlocal, -sina, cosa, -sinb, cosb,&
                -sing, cosg, xgloba)
end subroutine
