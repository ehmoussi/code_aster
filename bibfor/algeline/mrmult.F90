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

subroutine mrmult(cumul, lmat, vect, xsol, nbvect,&
                  prepos)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmmvr.h"
#include "asterfort/mtdsc2.h"
#include "asterfort/mtmchc.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
    character(len=*) :: cumul
    integer :: lmat, nbvect
    real(kind=8) :: vect(*), xsol(*)
    aster_logical :: prepos, prepo2
!    EFFECTUE LE PRODUIT D'UNE MATRICE PAR N VECTEURS REELS. LE RESULTAT
!    EST STOCKE DANS N VECTEURS REELS
!     ATTENTION:
!       - MATRICE SYMETRIQUE OU NON, REELLE.
!       - LES VECTEURS INPUT ET OUTPUT REELS DOIVENT ETRE DISTINCTS
!       - POUR LES DDLS ELIMINES PAR AFFE_CHAR_CINE, ON NE PEUT PAS
!         CALCULER XSOL. CES DDLS SONT MIS A ZERO.
!     ------------------------------------------------------------------
! IN  CUMUL  : K4 :
!              / 'ZERO' : XSOL =        MAT*VECT
!              / 'CUMU' : XSOL = XSOL + MAT*VECT
!
! IN  LMAT  :I:  DESCRIPTEUR DE LA MATRICE
! IN  VECT  :R: VECTEUR(S) A MULTIPLIER PAR LA MATRICE
! VAR XSOL  :R: VECTEUR(S) SOLUTION(S)
!               SI CUMUL = 'ZERO' ALORS XSOL EST EN MODE OUT
! IN  NBVECT: I : NOMBRE DE VECTEURS A MULTIPLIER (ET DONC DE SOLUTIONS)
!     ------------------------------------------------------------------
    character(len=3) :: kmpic, kmatd
    character(len=19) :: matas
    integer :: neq, neql, jsmhc, jsmdi
    aster_logical :: lmatd
    real(kind=8), pointer :: vectmp(:) => null()
    real(kind=8), pointer :: xtemp(:) => null()
    character(len=24), pointer :: refa(:) => null()
!     ---------------------------------------------------------------
!
    prepo2=prepos
    call jemarq()
    ASSERT(cumul.eq.'ZERO' .or. cumul.eq.'CUMU')
    matas=zk24(zi(lmat+1))(1:19)
    ASSERT(zi(lmat+3).eq.1)
    call jeveuo(matas//'.REFA', 'L', vk24=refa)
    if (refa(3) .eq. 'ELIMF') call mtmchc(matas, 'ELIML')
    neq=zi(lmat+2)
    AS_ALLOCATE(vr=vectmp, size=neq)
!
    call jeveuo(refa(2)(1:14)//'.SMOS.SMHC', 'L', jsmhc)
    call mtdsc2(zk24(zi(lmat+1)), 'SMDI', 'L', jsmdi)
    call dismoi('MPI_COMPLET', matas, 'MATR_ASSE', repk=kmpic)
!
!
!     1.  MATRICE MPI_INCOMPLET :
!     ----------------------------
    if (kmpic .eq. 'NON') then
        if (cumul .eq. 'CUMU') then
            AS_ALLOCATE(vr=xtemp, size=nbvect*neq)
            call dcopy(nbvect*neq, xsol, 1, xtemp, 1)
        endif
!
        call dismoi('MATR_DISTR', matas, 'MATR_ASSE', repk=kmatd)
        if (kmatd .eq. 'OUI') then
            lmatd=.true.
            neql=zi(lmat+5)
        else
            lmatd=.false.
            neql=0
        endif
        call mrmmvr('ZERO', lmat, zi(jsmdi), zi4(jsmhc), lmatd,&
                    neq, neql, vect, xsol, nbvect,&
                    vectmp, prepo2)
!       ON DOIT COMMUNIQUER POUR OBTENIR LE PRODUIT MAT-VEC 'COMPLET'
        call asmpi_comm_vect('MPI_SUM', 'R', nbval=nbvect*neq, vr=xsol)
!
        if (cumul .eq. 'CUMU') then
            call daxpy(nbvect*neq, 1.d0, xtemp, 1, xsol,&
                       1)
            AS_DEALLOCATE(vr=xtemp)
        endif
!
!
!     2.  MATRICE MPI_COMPLET :
!     ----------------------------
    else
        lmatd=.false.
        neql=0
        call mrmmvr(cumul, lmat, zi(jsmdi), zi4(jsmhc), lmatd,&
                    neq, neql, vect, xsol, nbvect,&
                    vectmp, prepo2)
    endif
!
!
    AS_DEALLOCATE(vr=vectmp)
    call jedema()
end subroutine
