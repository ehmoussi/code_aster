! --------------------------------------------------------------------
! Copyright (C) 2019 Christophe Durand - www.code-aster.org
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterc/r8dgrd.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/matrot.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/uttgel.h"
#include "asterfort/rccoma.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/utrcyl.h"
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
    integer :: nbres
    parameter (nbres=3)
    integer :: icodre(nbres)
    character(len=2) :: typgeo
    character(len=32) :: phenom
    real(kind=8) :: rhocp, lambda, theta, deltat, khi, tpgi
    real(kind=8) :: p(3,3), dfdx(27), dfdy(27), dfdz(27), poids, r8bid
    real(kind=8) :: tpsec, diff, lambor(3), orig(3), dire(3)
    real(kind=8) :: point(3), angl(3), fluloc(3), fluglo(3)
    real(kind=8) :: alpha, beta
    integer :: ipoids, ivf, idfde, igeom, imate, icamas
    integer :: jgano, nno, kp, npg, i, j, ij, l, imattt, itemps, ifon(6)
    integer :: isechi, isechf
    integer :: icomp, itempi, nnos, ndim, nuno, n1, n2
    integer :: npg2, ipoid2, ivf2, idfde2
    aster_logical :: aniso, global
!
!====
! 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
!====
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
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PMATTTR', 'E', imattt)
!
    deltat = zr(itemps+1)
    theta  = zr(itemps+2)
    khi    = zr(itemps+3)
!
    if (zk16(icomp)(1:5) .eq. 'THER_') then
!====
! --- THERMIQUE
!====
        call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
        aniso = .false.
        if (phenom(1:12) .eq. 'THER_NL_ORTH') then
            aniso  = .true.
        endif
        call ntfcma(zk16(icomp), zi(imate), aniso, ifon)
!
! ---   TRAITEMENT DE L ANISOTROPIE
!
        global = .false.
        if (aniso) then
            call jevech('PCAMASS', 'L', icamas)
            if (zr(icamas) .gt. 0.d0) then
                global = .true.
                angl(1) = zr(icamas+1)*r8dgrd()
                angl(2) = zr(icamas+2)*r8dgrd()
                angl(3) = zr(icamas+3)*r8dgrd()
                call matrot(angl, p)
            else
                alpha = zr(icamas+1)*r8dgrd()
                beta  = zr(icamas+2)*r8dgrd()
                dire(1) =  cos(alpha)*cos(beta)
                dire(2) =  sin(alpha)*cos(beta)
                dire(3) = -sin(beta)
                orig(1) = zr(icamas+4)
                orig(2) = zr(icamas+5)
                orig(3) = zr(icamas+6)
            endif
        endif
!
! ---   CALCUL DU PREMIER TERME
!
        do 40 kp = 1, npg
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
!
! ---       EVALUATION DE LA CONDUCTIVITE LAMBDA
!
            tpgi = 0.d0
            do 10 i = 1, nno
                tpgi = tpgi + zr(itempi+i-1)*zr(ivf+l+i-1)
10          continue
            if (aniso) then
                call rcfode(ifon(4), tpgi, lambor(1), r8bid)
                call rcfode(ifon(5), tpgi, lambor(2), r8bid)
                call rcfode(ifon(6), tpgi, lambor(3), r8bid)
            else
                call rcfode(ifon(2), tpgi, lambda, r8bid)
            endif
!
! ---       TRAITEMENT DE L ANISOTROPIE
!
            if (.not.global .and. aniso) then
                point(1) = 0.d0
                point(2) = 0.d0
                point(3) = 0.d0
                do 20 nuno = 1, nno
                    point(1) = point(1) + zr(ivf+l+nuno-1)*zr(igeom+3* nuno-3)
                    point(2) = point(2) + zr(ivf+l+nuno-1)*zr(igeom+3* nuno-2)
                    point(3) = point(3) + zr(ivf+l+nuno-1)*zr(igeom+3* nuno-1)
 20             continue
                call utrcyl(point, dire, orig, p)
            endif
!
            do 30 i = 1, nno
                if (.not.aniso) then
                    fluglo(1) = lambda*dfdx(i)
                    fluglo(2) = lambda*dfdy(i)
                    fluglo(3) = lambda*dfdz(i)
                else
                    fluglo(1) = dfdx(i)
                    fluglo(2) = dfdy(i)
                    fluglo(3) = dfdz(i)
                    n1 = 1
                    n2 = 3
                    call utpvgl(n1, n2, p, fluglo, fluloc)
                    fluloc(1) = lambor(1)*fluloc(1)
                    fluloc(2) = lambor(2)*fluloc(2)
                    fluloc(3) = lambor(3)*fluloc(3)
                    n1 = 1
                    n2 = 3
                    call utpvlg(n1, n2, p, fluloc, fluglo)
                endif
!
! ---       CALCUL DE LA PREMIERE COMPOSANTE DU TERME ELEMENTAIRE
!
                do 45 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids*theta*&
                                      &(fluglo(1)*dfdx(j)+fluglo(2)*dfdy(j)+fluglo(3)*dfdz(j))
45              continue
30          continue
40      continue
!
! ---   CALCUL DU DEUXIEME TERME
!
        do 80 kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
!
! ---       EVALUATION DE LA CAPACITE CALORIFIQUE
! ---       PAS DE TRAITEMENT POUR L ORTHOTROPIE (RHOCP NON CONCERNE)
!
            tpgi = 0.d0
            do 50 i = 1, nno
                tpgi = tpgi + zr(itempi+i-1)*zr(ivf2+l+i-1)
50          continue
            call rcfode(ifon(1), tpgi, r8bid, rhocp)
!
! ---       CALCUL DE LA DEUXIEME COMPOSANTE DU TERME ELEMENTAIRE
!
            do 70 i = 1, nno
                do 60 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1)+ &
                                      & poids*khi*rhocp*zr(ivf2+l+i-1)*zr(ivf2+l+j-1)/deltat
60              continue
70          continue
80      continue
!
    else if (zk16(icomp) (1:5).eq.'SECH_') then
!====
! --- SECHAGE
!====
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
            tpgi  = 0.d0
            tpsec = 0.d0
            do 100 i = 1, nno
                tpgi  = tpgi  + zr(itempi+i-1)*zr(ivf+l+i-1)
                tpsec = tpsec + zr(isechf+i-1)*zr(ivf+l+i-1)
100          continue
            call rcdiff(zi(imate), zk16(icomp), tpsec, tpgi, diff)
            do 110 i = 1, nno
!
                do 120 j = 1, i
                    ij = (i-1)*i/2 + j
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids*&
                                      & ( theta* diff*&
                                          & (dfdx(i)*dfdx(j)+dfdy(i)*dfdy(j)+dfdz(i)*dfdz(j)) )
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
                    zr(imattt+ij-1) = zr(imattt+ij-1) + poids*&
                                      & (khi*zr(ivf2+l+i-1)*zr(ivf2+l+j-1)/deltat)
121              continue
111          continue
91      continue
!
    endif
!
! FIN ------------------------------------------------------------------
end subroutine
