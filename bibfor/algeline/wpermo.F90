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

subroutine wpermo(lmasse, lraide, lamor, nbprop, vecp,&
                  fr, am, excl, omecor, ernorm)
    implicit none
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/freqom.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/mcmult.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: lmasse, lraide, lamor, nbprop, excl(*)
    complex(kind=8) :: vecp(*)
    real(kind=8) :: fr(*), am(*), omecor, ernorm(*)
!     CALCUL DE LA NORME D'ERREUR MODALE
!     ( IE NORME D'ERREUR SUR LES VALEURS ET VECTEURS PROPRES.)
!     ------------------------------------------------------------------
!     PROBLEME QUADRATIQUE:
!
!                   !! LRAIDE * VECP  - VALP * LMASSE * VECP !!
!       ERNORM   =     -------------------------------------
!                           !! LRAIDE * VECP !!
!     ------------------------------------------------------------------
!     REFERENCE:
!     ------------------------------------------------------------------
! IN  LMASSE : IS : DESCRIPTEUR MATRICE DE "MASSE"
! IN  LRAIDE : IS : DESCRIPTEUR MATRICE DE "RAIDEUR"
! IN  LAMOR  : IS : DESCRIPTEUR MATRICE D'AMORTISSEMENT
! IN  NBPROP : IS : NOMBRE DE VALEURS ET DE VECTEURS PROPRES
! IN  VECP   : R8 : TABLEAU DES VECTEURS PROPRES
! IN  VALP   : R8 : TABLEAU DES VALEURS PROPRES
! IN  EXCL   : IS : TABLEAU DES NON-EXCLUS
! IN  FCORIG : R8 : FREQUENCE MODE DE CORPS RIGIDE
! OUT ERNORM : R8 : TABLEAU DES NORMES D'ERREUR
!     ------------------------------------------------------------------
!
!
!     ------------------------------------------------------------------
    real(kind=8) :: anorm1, anorm2, xseuil
    real(kind=8) :: valr
    real(kind=8) :: depi, isig
    complex(kind=8) :: freq, freq2
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, iaux1, iaux2, iaux3, iaux4, ivec, j
    integer :: neq
    real(kind=8) :: ami, fri
!-----------------------------------------------------------------------
    call jemarq()
    depi = r8depi()
    xseuil = omecor
    neq = zi(lmasse+2)
!
    call wkvect('&&WPERMO.TAMPON.PROV_1', 'V V C', neq, iaux1)
    call wkvect('&&WPERMO.TAMPON.PROV_2', 'V V C', neq, iaux2)
    call wkvect('&&WPERMO.TAMPON.PROV_3', 'V V C', neq, iaux3)
    call wkvect('&&WPERMO.TYPEDDL      ', 'V V I', neq, iaux4)
!
    do 1 i = 1, nbprop
!
        ivec=(i-1)*neq+1
        do 10 j = 0, neq-1
            vecp(ivec+j) = vecp(ivec+j) * excl(j+1)
10      continue
!
        ami = am(i)
        if (abs(ami) .eq. 1.d0) then
            ernorm(i)= 1.d+70
            valr = 1.0d70
            call utmess('A', 'ALGELINE4_74', sr=valr)
        else
            fri = freqom(fr(i))*depi
            isig=-sign(1.d0,ami)
            ami = isig*abs(ami*fri)/sqrt(1.d0-ami*ami)
            freq = dcmplx( ami, fri)
            freq2 = freq*freq
            call mcmult('ZERO', lraide, vecp(ivec), zc(iaux1), 1,&
                        .false._1)
            call mcmult('ZERO', lmasse, vecp(ivec), zc(iaux2), 1,&
                        .false._1)
            call mcmult('ZERO', lamor, vecp(ivec), zc(iaux3), 1,&
                        .false._1)
            do 2 j = 0, neq-1
                zc(iaux2+j)=zc(iaux1+j)+freq*zc(iaux3+j)+freq2*zc(&
                iaux2+j)
 2          continue
!
!           --- ON PREND LA NORME EUCLIDIENNE ---
            anorm1 = 0.d0
            anorm2 = 0.d0
            do 3 j = 0, neq-1
                anorm1 = anorm1 + dble( dconjg(zc(iaux1+j))*zc(iaux1+j) *excl(j+1))
                anorm2 = anorm2 + dble( dconjg(zc(iaux2+j))*zc(iaux2+j) *excl(j+1))
 3          continue
            if (abs(freq) .gt. xseuil) then
                if (anorm1 .ne. 0.d0) then
                    ernorm(i)= sqrt( anorm2 / anorm1 )
                else
                    ernorm(i)= 1.d+70
                endif
            else
                ernorm(i) = abs(freq) * sqrt( anorm2 )
            endif
!
        endif
 1  end do
!
    call jedetr('&&WPERMO.TAMPON.PROV_1')
    call jedetr('&&WPERMO.TAMPON.PROV_2')
    call jedetr('&&WPERMO.TAMPON.PROV_3')
    call jedetr('&&WPERMO.TYPEDDL      ')
!
    call jedema()
end subroutine
