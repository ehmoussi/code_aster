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

subroutine te0279(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/uttgel.h"
!
    character(len=16) :: nomte, option
! ----------------------------------------------------------------------
!
!    - FONCTION REALISEE:  CALCUL DES MATRICES TANGENTES ELEMENTAIRES
!                          OPTION : 'MTAN_RIGI_MASS'
!                          ELEMENTS 3D ISO PARAMETRIQUES LUMPES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE
!
!
!
!
!
    character(len=2) :: typgeo
    real(kind=8) :: rhocp, lambda, theta, deltat, khi, tpgi
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids, r8bid
    real(kind=8) :: tpsec, diff
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: jgano, nno, kp, npg, i, j, ij, l, imattt, itemps, ifon(3)
    integer :: isechi, isechf
    integer :: icomp, itempi, nnos, ndim
    integer :: npg2, ipoid2, ivf2, idfde2
! DEB ------------------------------------------------------------------
    call uttgel(nomte, typgeo)
    if ((lteatt('LUMPE','OUI')) .and. (typgeo.ne.'PY')) then
        call elrefe_info(fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg2,jpoids=ipoid2,jvf=ivf2,jdfde=idfde2,jgano=jgano)
    else
        call elrefe_info(fami='MASS',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg2,jpoids=ipoid2,jvf=ivf2,jdfde=idfde2,jgano=jgano)
    endif
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PMATTTR', 'E', imattt)
!
    deltat = zr(itemps+1)
    theta = zr(itemps+2)
    khi = zr(itemps+3)
!
    if (zk16(icomp) (1:5) .eq. 'THER_') then
!
        call ntfcma(zk16(icomp), zi(imate), ifon)
!
        do 40 kp = 1, npg
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpgi = 0.d0
            do 10 i = 1, nno
                tpgi = tpgi + zr(itempi+i-1)*zr(ivf+l+i-1)
10          continue
            call rcfode(ifon(2), tpgi, lambda, r8bid)
!
            do 30 i = 1, nno
                do 20 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids*theta* lambda* (dfdx(i)*dfdx(j)+ df&
                                      &dy(i)*dfdy(j)+dfdz(i)* dfdz(j))
20              continue
30          continue
40      continue
!
        do 80 kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpgi = 0.d0
            do 50 i = 1, nno
                tpgi = tpgi + zr(itempi+i-1)*zr(ivf2+l+i-1)
50          continue
            call rcfode(ifon(1), tpgi, r8bid, rhocp)
!
            do 70 i = 1, nno
                do 60 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids*khi* rhocp*zr(ivf2+l+i-1)* zr(ivf2+&
                                      &l+j-1)/deltat
60              continue
70          continue
80      continue
!
    else if (zk16(icomp) (1:5).eq.'SECH_') then
!
! --- SECHAGE
!
        if (zk16(icomp) (1:12) .eq. 'SECH_GRANGER' .or. zk16(icomp) (1: 10) .eq.&
            'SECH_NAPPE') then
            call jevech('PTMPCHI', 'L', isechi)
            call jevech('PTMPCHF', 'L', isechf)
        else
!          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
!          ISECHI ET ISECHF SONT FICTIFS
            isechi = itempi
            isechf = itempi
        endif
        do 90 kp = 1, npg
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpgi = 0.d0
            tpsec = 0.d0
            do 100 i = 1, nno
                tpgi = tpgi + zr(itempi+i-1)*zr(ivf+l+i-1)
                tpsec = tpsec + zr(isechf+i-1)*zr(ivf+l+i-1)
100          continue
            call rcdiff(zi(imate), zk16(icomp), tpsec, tpgi, diff)
            do 110 i = 1, nno
!
                do 120 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids* (theta* diff* (dfdx(i)*dfdx(j)+ df&
                                      &dy(i)*dfdy(j)+dfdz(i)* dfdz(j)))
120              continue
110          continue
90      continue
        do 91 kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            do 111 i = 1, nno
!
                do 121 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids* (khi*zr(ivf2+l+i-1)*zr(ivf2+l+j-1)&
                                      &/deltat)
121              continue
111          continue
91      continue
!
    endif
!
! FIN ------------------------------------------------------------------
end subroutine
