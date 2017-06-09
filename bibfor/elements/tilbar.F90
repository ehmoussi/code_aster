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

subroutine tilbar(stild, vectt, bars)
!
    implicit none
!
#include "asterfort/btkb.h"
#include "asterfort/sigbar.h"
#include "asterfort/sigvte.h"
    real(kind=8) :: stild ( 5 )
    real(kind=8) :: vectt ( 3 , 3 )
    real(kind=8) :: bars ( 9 , 9 )
!
    real(kind=8) :: bid33 ( 3 , 3 )
!
    real(kind=8) :: stil ( 3 , 3 )
!
!
    real(kind=8) :: s ( 3 , 3 )
!
!DEB
!
!---- TENSEUR 3 * 3 CONTRAINTES LOCALES
!
    call sigvte(stild, stil)
!
!---- ROTATION DU TENSEUR CONTRAINTES : LOCALES --> GLOBALES
!
!              S     =  ( VECTT ) T * STIL  * VECTT
!
    call btkb(3, 3, 3, stil, vectt,&
              bid33, s)
!
!---- BARS   ( 9 , 9 )
!
    call sigbar(s, bars)
!
!
! FIN
!
end subroutine
