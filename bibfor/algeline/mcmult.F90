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

subroutine mcmult(cumul, lmat, vect, xsol, nbvect,&
                  prepos)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mcmmvc.h"
#include "asterfort/mcmmvr.h"
#include "asterfort/mtdsc2.h"
#include "asterfort/mtmchc.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    character(len=*) :: cumul
    integer :: lmat, nbvect
    complex(kind=8) :: vect(*), xsol(*)
    aster_logical :: prepos, prepo2
!     EFFECTUE LE PRODUIT D'UNE MATRICE PAR N VECTEURS COMPLEXES.
!     LE RESULTAT EST STOCKE DANS N VECTEURS COMPLEXES
!     ATTENTION:
!       - MATRICE SYMETRIQUE OU NON, REELLE OU COMPLEXE
!       - VECTEURS INPUT ET OUTPUT COMPLEXES ET DISTINCTS
!       - POUR LES DDLS ELIMINES PAR AFFE_CHAR_CINE, ON NE PEUT PAS
!         CALCULER XSOL. CES DDLS SONT MIS A ZERO.
!     ------------------------------------------------------------------
! IN  CUMUL  : K4 :
!              / 'ZERO' : XSOL =        MAT*VECT
!              / 'CUMU' : XSOL = XSOL + MAT*VECT
!
! IN  LMAT  : I : DESCRIPTEUR DE LA MATRICE
! IN  VECT  :R/C: VECTEURS A MULTIPLIER PAR LA MATRICE
! VAR XSOL  :R/C: VECTEUR(S) SOLUTION(S)
!               SI CUMUL = 'ZERO' ALORS XSOL EST EN MODE OUT
! IN  NBVECT: I : NOMBRE DE VECTEURS A MULTIPLIER (ET DONC DE SOLUTIONS)
!     ------------------------------------------------------------------
    character(len=3) :: kmpic
    character(len=19) :: matas
    integer :: jsmdi, jsmhc, neq
    complex(kind=8), pointer :: vectmp(:) => null()
    character(len=24), pointer :: refa(:) => null()
!
    call jemarq()
    prepo2=prepos
    matas=zk24(zi(lmat+1))(1:19)
    call jeveuo(matas//'.REFA', 'L', vk24=refa)
    if (refa(3) .eq. 'ELIMF') call mtmchc(matas, 'ELIML')
!
    call dismoi('MPI_COMPLET', matas, 'MATR_ASSE', repk=kmpic)
    if (kmpic .ne. 'OUI') then
        call utmess('F', 'CALCULEL6_54')
    endif
!
    call jeveuo(refa(2)(1:14)//'.SMOS.SMHC', 'L', jsmhc)
    neq=zi(lmat+2)
    AS_ALLOCATE(vc=vectmp, size=neq)
!
!
!     SELON REEL OU COMPLEXE :
    if (zi(lmat+3) .eq. 1) then
!
        call mtdsc2(zk24(zi(lmat+1)), 'SMDI', 'L', jsmdi)
        call mcmmvr(cumul, lmat, zi(jsmdi), zi4(jsmhc), neq,&
                    vect, xsol, nbvect, vectmp, prepo2)
!
    else if (zi(lmat+3) .eq. 2) then
!
!     MATRICE COMPLEXE
        call mtdsc2(zk24(zi(lmat+1)), 'SMDI', 'L', jsmdi)
        call mcmmvc(cumul, lmat, zi(jsmdi), zi4(jsmhc), neq,&
                    vect, xsol, nbvect, vectmp, prepo2)
!
    else
!
        call utmess('F', 'ALGELINE_66')
!
    endif
!
    AS_DEALLOCATE(vc=vectmp)
    call jedema()
end subroutine
