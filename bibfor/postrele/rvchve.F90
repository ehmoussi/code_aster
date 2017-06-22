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

subroutine rvchve(iocc, xpi, ypi, zpi)
! aslint: disable=W1501
    implicit none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/matrot.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
#include "asterfort/assert.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
!
    integer, intent(in) :: iocc
    real(kind=8), intent(inout) :: xpi,ypi,zpi
! ----------------------------------------------------------------------
!
!     but : Faire subir au vecteur (xpi, ypi, zpi) la rotation correspondant
!           au repere 'UTILISATEUR'.
!           Ne traite que le cas repere='UTILISATEUR' (angl_naut)
! ----------------------------------------------------------------------
!     arguments :
!     xpi    in/out  r    : 1ere coordonnee du vecteur
!     ypi    in/out  r    : 2eme coordonnee du vecteur
!     zpi    in/out  r    : 3eme coordonnee du vecteur
! ---------------------------------------------------------------------
!
    integer ::  n1
    real(kind=8) :: angnot(3), pgl(3, 3), pm(3), pm2(3)
    character(len=16) ::  repere
! ---------------------------------------------------------------------

    call getvtx('ACTION', 'REPERE', iocc=iocc, scal=repere, nbret=n1)
    ASSERT(n1.eq.1)
    if (repere.ne.'UTILISATEUR'.and.repere.ne.'GLOBAL') then
        call utmess('F','POSTRELE_68')
    endif

    if (repere.eq.'GLOBAL') goto 999

    call getvr8('ACTION', 'ANGL_NAUT', iocc=iocc, nbval=3, vect=angnot, nbret=n1)
    ASSERT(n1.eq.3)

    angnot(1) = angnot(1)*r8dgrd()
    angnot(2) = angnot(2)*r8dgrd()
    angnot(3) = angnot(3)*r8dgrd()

    call matrot(angnot, pgl)

    pm(1)=xpi
    pm(2)=ypi
    pm(3)=zpi

    call utpvgl(1, 3, pgl, pm, pm2)

    xpi=pm2(1)
    ypi=pm2(2)
    zpi=pm2(3)

999 continue
!
end subroutine
