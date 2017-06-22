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

subroutine ssvau1(nomacr, iavein, iaveou)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mrconl.h"
#include "asterfort/mtdsc2.h"
#include "asterfort/mtdscr.h"
#include "asterfort/rldlr8.h"
    character(len=8) :: nomacr
    integer :: iavein, iaveou
! ----------------------------------------------------------------------
!     BUT:
!         "CONDENSER" UN  VECTEUR CHARGEMENT D'UN MACR_ELEM_STAT :
!          EN ENTREE :
!            VECIN  (     1,NDDLI      )  =  F_I (EVENT. TOURNE)
!            VECIN  (NDDLI+1,NDDLI+NDDLE) =  F_E (EVENT. TOURNE)
!
!          EN SORTIE :
!            VECOUT(       1,NDDLI      ) = (KII**-1)*F_I
!            VECOUT(NDDLI+1,NDDLI+NDDLE)  =  FP_E
!            OU FP_E = F_E - K_EI*(KII**-1)*F_I
!
!     IN: NOMACR : NOM DU MACR_ELEM_STAT
!         IAVEIN : ADRESSE DANS ZR DU VECTEUR A CONDENSER.(VECIN)
!         IAVEOU : ADRESSE DANS ZR DU VECTEUR CONDENSE.(VECOUT)
!
!         IMPORTANT : LES 2 ADRESSES IAVEIN ET IAVEOU PEUVENT ETRE
!                     IDENTIQUES (CALCUL EN PLACE).
!
!     OUT:   LE VECTEUR VECOUT EST CALCULE.
! ----------------------------------------------------------------------
!
!
    integer :: scdi, schc, iblo
    character(len=19) :: matas, stock, nu
!
!-----------------------------------------------------------------------
    integer ::  iascbl, iascdi,   iblold, j
    integer ::  jualf, k, kk, lmat, nbbloc, nddle
    integer :: nddli, nddlt
    integer, pointer :: desm(:) => null()
    integer, pointer :: vschc(:) => null()
    character(len=24), pointer :: refa(:) => null()
    integer, pointer :: scib(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
    matas=nomacr//'.RIGIMECA'
    nu=nomacr
    nu=nu(1:14)//'.NUME'
    stock=nu(1:14)//'.SLCS'
    call jeveuo(stock//'.SCIB', 'L', vi=scib)
!
!
    call jeveuo(nomacr//'.DESM', 'L', vi=desm)
    nddle=desm(4)
    nddli=desm(5)
    nddlt=nddli+nddle
!
!
!     -- ON RECOPIE VECIN DANS VECOUT POUR EVITER LES EFFETS DE BIAIS:
!     ---------------------------------------------------------------
    do 10,kk=1,nddlt
    zr(iaveou-1+kk)=zr(iavein-1+kk)
    10 end do
!
!
!     -- ON COMMENCE PAR CONDITIONNER LE SECOND MEMBRE INITIAL (.CONL)
!     ------------------- -------------------------------------------
    call mtdscr(matas)
    call jeveuo(matas(1:19)//'.&INT', 'E', lmat)
    call mrconl('MULT', lmat, nddlt, 'R', zr(iaveou),&
                1)
!
!
!     -- CALCUL DE QI0 = (K_II**(-1))*F_I DANS : VECOUT(1->NDDLI):
!     ------------------- ----------------------------------------
    call jeveuo(zk24(zi(lmat+1))(1:19)//'.REFA', 'L', vk24=refa)
    call jeveuo(refa(2)(1:14)//'.SLCS.SCHC', 'L', vi=vschc)
    call mtdsc2(zk24(zi(lmat+1)), 'SCDI', 'L', iascdi)
    call mtdsc2(zk24(zi(lmat+1)), 'SCBL', 'L', iascbl)
    call jelira(matas//'.UALF', 'NMAXOC', nbbloc)
!
    call rldlr8(zk24(zi(lmat+1)), vschc, zi(iascdi), zi(iascbl), nddli,&
                nbbloc, zr(iaveou), 1)
!
!
!     -- CALCUL DE FP_E = F_E-K_EI*QI0 DANS : VECOUT(NDDLI+1,NDDLT):
!     -----------------------------------------------------------------
    iblold=0
    do 30,j=1,nddle
    iblo=scib(nddli+j)
    scdi=zi(iascdi-1+nddli+j)
    schc=vschc(nddli+j)
    if (iblo .ne. iblold) then
        if (iblold .gt. 0) call jelibe(jexnum(matas//'.UALF', iblold))
        call jeveuo(jexnum(matas//'.UALF', iblo), 'L', jualf)
    endif
    iblold=iblo
    kk=0
    do 20,k=nddli+j+1-schc,nddli
    kk=kk+1
    zr(iaveou-1+nddli+j)=zr(iaveou-1+nddli+j)- zr(iaveou-1+k)*&
            zr(jualf-1+scdi-schc+kk)
20  continue
    30 end do
    if (iblold .gt. 0) call jelibe(jexnum(matas//'.UALF', iblold))
!
!
    call jelibe(refa(2)(1:14)//'.SLCS.SCHC')
!
    call jedema()
end subroutine
