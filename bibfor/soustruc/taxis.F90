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

subroutine taxis(noma, indic, nbma)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbliva.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: noma
    integer :: indic(*)
    integer :: nbma
! ----------------------------------------------------------------------
!     BUT: VERIFIER QUE LES COORDONNEES SONT POSITIVES
!
!     IN: NOMA   : NOM DU MAILLAGE
!         INDIC  : INDICATEUR DES MAILLES A TRAITER.
!           NBMA : NOMBRE DE MAILLES
!
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: valr(1), xmax, toler, r8b
    complex(kind=8) :: c16b
!
    character(len=8) :: k8b, k8a
    character(len=24) :: valk(2)
    character(len=19) :: tablg
!
!-----------------------------------------------------------------------
    integer :: iacnex, ier, ima, ino,  nbnoma, numno, iret, ibid
    real(kind=8), pointer :: vale(:) => null()
!
!-----------------------------------------------------------------------
    call jemarq()
    r8b=0.d0
!
!     TOLERANCE POUR DES ABSCISSES TRES LEGEREMENT < 0 : 1.E-6*X_MAX
    call ltnotb(noma, 'CARA_GEOM', tablg)
    call tbliva(tablg, 0, ' ', [ibid], [r8b],&
                [c16b], k8b, k8b, [r8b], 'X_MAX',&
                k8b, ibid, xmax, c16b, k8b,&
                iret)
    ASSERT(iret.eq.0)
    toler=-1.d-6*abs(xmax)
!
!
!     -- ON PARCOURE LA LISTE DES MAILLES ET ON TESTE LES NOEUDS
!
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
    ier=0
    do ima = 1, nbma
        if (indic(ima) .ne. 0) then
            call jeveuo(jexnum(noma//'.CONNEX', ima), 'L', iacnex)
            call jelira(jexnum(noma//'.CONNEX', ima), 'LONMAX', nbnoma)
            do ino = 1, nbnoma
                numno=zi(iacnex-1+ino)-1
                if (vale(1+3*numno) .lt. toler) then
                    call jenuno(jexnum(noma//'.NOMNOE', numno+1), k8b)
                    call jenuno(jexnum(noma//'.NOMMAI', ima ), k8a)
                    valk (1) = k8b
                    valk (2) = k8a
                    valr (1) = vale(1+3*numno)
                    call utmess('F+', 'MAILLAGE1_2', nk=2, valk=valk, sr=valr(1))
                    ier = ier + 1
                endif
            end do
        endif
    end do
    if (ier .ne. 0) then
        call utmess('F', 'MAILLAGE1_3')
    endif
!
    call jedema()
end subroutine
