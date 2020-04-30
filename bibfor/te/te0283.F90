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

subroutine te0283(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/matrot.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/ppgan2.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/rcvalb.h"
#include "asterfort/runge6.h"
#include "asterfort/uttgel.h"
#include "asterfort/rccoma.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/utrcyl.h"
#include "asterc/r8dgrd.h"
!
    character(len=16) :: nomte, option
! ----------------------------------------------------------------------
!
!    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
!                          OPTION : 'RESI_RIGI_MASS'
!                          ELEMENTS 3D ISO PARAMETRIQUES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE
!
!
!
    integer :: nbres
    parameter (nbres=3)
    integer :: icodre(nbres)
    character(len=2) :: typgeo
    character(len=32) :: phenom
    real(kind=8) :: beta, lambda, theta, deltat, khi, tpg, tpgm, r8bid
    real(kind=8) :: p(3,3), dfdx(27), dfdy(27), dfdz(27), poids, hydrgm(27)
    real(kind=8) :: dtpgdx, dtpgdy, dtpgdz, rbid, chal(1), hydrgp(27)
    real(kind=8) :: tpsec, diff, err, lambor(3), orig(3), dire(3)
    real(kind=8) :: point(3), angl(3), fluloc(3), fluglo(3)
    real(kind=8) :: aalpha, abeta
    integer :: ipoids, ivf, idfde, igeom, imate, icamas
    integer :: jgano, nno, kp, npg1, i, itemps, ifon(6), l, ndim
    integer :: ihydr, ihydrp, itempr
    integer :: isechi, isechf, jgano2
    integer :: icomp, itempi, iveres, nnos, nuno, n1, n2
    integer :: npg2, ipoid2, ivf2, idfde2
    aster_logical :: aniso, global
! ----------------------------------------------------------------------
! PARAMETER ASSOCIE AU MATERIAU CODE
! --- INDMAT : INDICE SAUVEGARDE POUR LE MATERIAU
!CC      PARAMETER        ( INDMAT = 8 )
! ----------------------------------------------------------------------
!====
! 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
!====
    call uttgel(nomte, typgeo)
    if ((lteatt('LUMPE','OUI')) .and. (typgeo.ne.'PY')) then
        call elrefe_info(fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
                         npg=npg2,jpoids=ipoid2,jvf=ivf2,jdfde=idfde2,jgano=jgano2)
    else
        call elrefe_info(fami='MASS',ndim=ndim,nno=nno,nnos=nnos,&
                         npg=npg2,jpoids=ipoid2,jvf=ivf2,jdfde=idfde2,jgano=jgano2)
    endif
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
                     npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PRESIDU', 'E', iveres)
!
    deltat = zr(itemps+1)
    theta  = zr(itemps+2)
    khi    = zr(itemps+3)
!
    if (zk16(icomp) (1:5) .eq. 'THER_') then
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
                aalpha = zr(icamas+1)*r8dgrd()
                abeta  = zr(icamas+2)*r8dgrd()
                dire(1) =  cos(aalpha)*cos(abeta)
                dire(2) =  sin(aalpha)*cos(abeta)
                dire(3) = -sin(abeta)
                orig(1) = zr(icamas+4)
                orig(2) = zr(icamas+5)
                orig(3) = zr(icamas+6)
            endif
        endif
!----
!   INITIALISATION THER_HYDR
!----
        if (zk16(icomp) (1:9) .eq. 'THER_HYDR') then
            call jevech('PHYDRPM', 'L', ihydr)
            call jevech('PHYDRPP', 'E', ihydrp)
            call jevech('PTEMPER', 'L', itempr)
            call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                        ' ', 'THER_HYDR', 0, ' ', [0.d0],&
                        1, 'CHALHYDR', chal, icodre(1), 1)
            do 150 kp = 1, npg2
                l = nno*(kp-1)
                hydrgm(kp)=0.d0
                do 160 i = 1, nno
                    hydrgm(kp)=hydrgm(kp)+zr(ihydr)*zr(ivf2+l+i-1)
160              continue
150          continue
        endif
!
! ---   CALCUL DU PREMIER TERME
!
        do 30 kp = 1, npg1
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg    = 0.d0
            dtpgdx = 0.d0
            dtpgdy = 0.d0
            dtpgdz = 0.d0
            do 10 i = 1, nno
                tpg    = tpg    + zr(itempi+i-1)*zr(ivf+l+i-1)
                dtpgdx = dtpgdx + zr(itempi+i-1)*dfdx(i)
                dtpgdy = dtpgdy + zr(itempi+i-1)*dfdy(i)
                dtpgdz = dtpgdz + zr(itempi+i-1)*dfdz(i)
10          continue
!
            if (.not.aniso) then
                call rcfode(ifon(2), tpg, lambda, rbid)
                fluglo(1) = lambda*dtpgdx
                fluglo(2) = lambda*dtpgdy
                fluglo(3) = lambda*dtpgdz
            else
!
! ---       TRAITEMENT DE L ANISOTROPIE
!
                call rcfode(ifon(4), tpg, lambor(1), r8bid)
                call rcfode(ifon(5), tpg, lambor(2), r8bid)
                call rcfode(ifon(6), tpg, lambor(3), r8bid)
                if (.not.global) then
                    point(1) = 0.d0
                    point(2) = 0.d0
                    point(3) = 0.d0
                    do 130 nuno = 1, nno
                        point(1) = point(1) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-3)
                        point(2) = point(2) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-2)
                        point(3) = point(3) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-1)
130                 continue
                    call utrcyl(point, dire, orig, p)
                endif
                fluglo(1) = dtpgdx
                fluglo(2) = dtpgdy
                fluglo(3) = dtpgdz
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
            do 20 i = 1, nno
                zr(iveres+i-1) = zr(iveres+i-1) + poids*theta*&
                                 &( dfdx(i)*fluglo(1)+ dfdy(i)*fluglo(2)+dfdz(i)*fluglo(3) )
20          continue
30      continue
!
! ---   CALCUL DU DEUXIEME TERME
!
        do 60 kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            do 40 i = 1, nno
                tpg = tpg + zr(itempi+i-1)*zr(ivf2+l+i-1)
40          continue
!
! ---       RESOLUTION DE L EQUATION D HYDRATATION
!
            if (zk16(icomp) (1:9) .eq. 'THER_HYDR') then
                tpgm = 0.d0
                hydrgp(kp)=0.d0
                do 51 i = 1, nno
                    tpgm = tpgm + zr(itempr+i-1)*zr(ivf2+l+i-1)
51              continue
                call runge6(ifon(3), deltat, tpg, tpgm, hydrgm(kp),&
                            hydrgp(kp), err)
            endif
!
            call rcfode(ifon(1), tpg, beta, rbid)
            if (zk16(icomp) (1:9) .eq. 'THER_HYDR') then
!
! ---           THERMIQUE NON LINEAIRE AVEC HYDRATATION
!
                do 61 i = 1, nno
                    zr(iveres+i-1) = zr(iveres+i-1) + poids*&
                                     & ((beta- chal(1)*hydrgp(kp)) / deltat*khi*zr(ivf2+l+i-1))
61              continue
            else
!
! ---           THERMIQUE NON LINEAIRE SEULE
!
                do 50 i = 1, nno
                    zr(iveres+i-1) = zr(iveres+i-1) + poids*&
                                     & beta                        / deltat*khi*zr(ivf2+l+i-1)
50              continue
            endif
60      continue
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
!
! ---   CALCUL DU PREMIER TERME
!
        do 70 kp = 1, npg1
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg    = 0.d0
            dtpgdx = 0.d0
            dtpgdy = 0.d0
            dtpgdz = 0.d0
            tpsec  = 0.d0
            do 80 i = 1, nno
                tpg = tpg + zr(itempi+i-1)*zr(ivf+l+i-1)
                tpsec  = tpsec  + zr(isechf+i-1)*zr(ivf+l+i-1)
                dtpgdx = dtpgdx + zr(itempi+i-1)*dfdx(i)
                dtpgdy = dtpgdy + zr(itempi+i-1)*dfdy(i)
                dtpgdz = dtpgdz + zr(itempi+i-1)*dfdz(i)
80          continue
            call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
            do 90 i = 1, nno
                zr(iveres+i-1) = zr(iveres+i-1) + poids*&
                                 & ( theta*diff*(dfdx(i)*dtpgdx+dfdy(i)*dtpgdy+dfdz(i)*dtpgdz) )
90          continue
70      continue
!
! ---   CALCUL DU DEUXIEME TERME
!
        do 71 kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            do 81 i = 1, nno
                tpg = tpg + zr(itempi+i-1)*zr(ivf2+l+i-1)
81          continue
            do 91 i = 1, nno
                zr(iveres+i-1) = zr(iveres+i-1) + poids* (1.d0/deltat*khi*zr(ivf2+l+i-1)*tpg)
91          continue
71      continue
    endif
!
    if (zk16(icomp) (1:9) .eq. 'THER_HYDR') call ppgan2(jgano2, 1, 1, hydrgp, zr(ihydrp))
!
! FIN ------------------------------------------------------------------
end subroutine
