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

subroutine vpfopc(lmasse, lraide, fmin, sigma, matopa,&
                  raide, lqz, solveu)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/mtdefs.h"
#include "asterfort/mtdscr.h"
#include "asterfort/preres.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: matopa, raide
    integer :: lmasse, lraide
    real(kind=8) :: fmin
    complex(kind=8) :: sigma
    aster_logical :: lqz
    character(len=19) :: solveu
!
!     DETERMINATION D'UN SHIFT ET CALCUL DE LA MATRICE SHIFTEE
!     DANS LE CAS GENERALISE COMPLEXE OU REEL NON SYM
!     ------------------------------------------------------------------
! OUT LDYNAM  : IS : POINTEUR SUR LA FACTORISEE DE LA MATRICE DYNAMIQUE
!                    INDUITE PAR L'OPTION
! OUT SIGMA   : C16: SHIFT
! IN  LQZ     : METHODE QZ OU NON
! IN  SOLVEU : K19 : SD SOLVEUR POUR PARAMETRER LE SOLVEUR LINEAIRE
!     ------------------------------------------------------------------
!
!
    integer :: lmat(2), lmatra, ibid
    character(len=24) :: nmat(2), nmatra
    real(kind=8) :: ashift, constc(3), fshift, valr(2)
    character(len=1) :: typcst(2)
    character(len=8) :: namddl
    character(len=19) :: matass, matpre
!
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data namddl/'        '/
!     ------------------------------------------------------------------
!
    call jemarq()
!
    matpre=' '
    lmat(1) = lmasse
    nmat(1) = zk24(zi(lmat(1)+1))
    lmat(2) = lraide
    nmat(2) = zk24(zi(lmat(2)+1))
!
    fshift = r8depi()*fmin
    ashift = 0.d0
!
    call getvr8('CALC_FREQ', 'AMOR_REDUIT', iocc=1, scal=ashift, nbret=ibid)
!
    if (abs(ashift) .ge. 1.d0) then
        ashift = 0.95d0
        valr (1) = 1.d0
        valr (2) = 0.95d0
        call utmess('I+', 'ALGELINE4_93')
        call utmess('I', 'ALGELINE4_96', nr=2, valr=valr)
    endif
!
    ashift = (ashift*fshift) / 2.0d0
    sigma = dcmplx(fshift,ashift)
!
! --- POUR QZ CALCUL DE LA MATRICE SHIFTEE ET DE SA FACTORISEE INUTILE
    if (lqz) goto 999
!
!        --- DECALAGE COMPLEXE ---
    call mtdefs(matopa, raide, 'V', 'C')
    call mtdscr(matopa)
    nmatra=matopa(1:19)//'.&INT'
    call jeveuo(matopa(1:19)//'.&INT', 'E', lmatra)
    typcst(1) = 'C'
    typcst(2) = 'R'
    constc(1) = -dble(sigma)
    constc(2) = -dimag(sigma)
    constc(3) = 1.d0
    call mtcmbl(2, typcst, constc, nmat, nmatra,&
                namddl, ' ', 'ELIM=')
!
!     --- FACTORISATION DES MATRICES ---
    matass=zk24(zi(lmatra+1))
    call preres(solveu, 'V', ibid, matpre, matass,&
                ibid, 2)
!
999 continue
    call jedema()
end subroutine
