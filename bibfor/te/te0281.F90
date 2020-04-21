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
!
subroutine te0281(option, nomte)
!
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_THER_EVOLNI'
!                          ELEMENTS 3D ISOPARAMETRIQUES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE LUMPE SANS HYDRATATION, NI SECHAGE
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
! PARAMETRES D'APPEL
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/matrot.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/utrcyl.h"
#include "asterfort/uttgel.h"
!
    character(len=16) :: nomte, option
!
    integer :: nbres
    parameter (nbres=3)
    integer :: icodre(nbres)
    character(len=2) :: typgeo
    character(len=32) :: phenom
    real(kind=8) :: beta, dbeta, lambda, theta, deltat, tpg
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids, dtpgdx, dtpgdy, dtpgdz
    real(kind=8) :: tpgbuf, tpsec, diff, chal(1), hydrpg(27)
    real(kind=8) :: p(3, 3), lambor(3), orig(3), dire(3), r8bid
    real(kind=8) :: point(3), angl(3), fluloc(3), fluglo(3)
    real(kind=8) :: aalpha, abeta
    integer :: jgano, ipoids, ivf, idfde, igeom, imate, itemp, icamas
    integer :: nno, kp, nnos
    integer :: npg, i, l, ifon(6), ndim, icomp, ivectt, ivecti
    integer :: itemps
    integer :: isechi, isechf, ihydr
    integer :: npg2, ipoid2, ivf2, idfde2, nuno, n1, n2
    aster_logical :: lhyd
    aster_logical :: aniso, global
!
!====
! 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
!====
    call uttgel(nomte, typgeo)
    if ((lteatt('LUMPE','OUI')) .and. (typgeo.ne.'PY')) then
        call elrefe_info(fami='NOEU', ndim=ndim, nno=nno, nnos=nnos, npg=npg2,&
                         jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano)
    else
        call elrefe_info(fami='MASS', ndim=ndim, nno=nno, nnos=nnos, npg=npg2,&
                         jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano)
    endif
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPER', 'L', itemp)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PVECTTR', 'E', ivectt)
    call jevech('PVECTTI', 'E', ivecti)
!
    deltat = zr(itemps+1)
    theta = zr(itemps+2)
!
!====
! 1.3 PREALABLES LIES A L'HYDRATATION
!====
    if (zk16(icomp) (1:9) .eq. 'THER_HYDR') then
        lhyd = .true.
        call jevech('PHYDRPM', 'L', ihydr)
        do kp = 1, npg2
            l = nno*(kp-1)
            hydrpg(kp)=0.d0
            do i = 1, nno
                hydrpg(kp)=hydrpg(kp)+zr(ihydr)*zr(ivf2+l+i-1)
            end do
        end do
!
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', 'THER_HYDR', 0, ' ', [0.d0],&
                    1, 'CHALHYDR', chal, icodre, 1)
    else
        lhyd = .false.
    endif
    if (zk16(icomp)(1:5) .eq. 'THER_') then
!
!====
! --- THERMIQUE
!====
!
        call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
        aniso = .false.
        if (phenom(1:12) .eq. 'THER_NL_ORTH') then
            aniso = .true.
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
                abeta = zr(icamas+2)*r8dgrd()
                dire(1) = cos(aalpha)*cos(abeta)
                dire(2) = sin(aalpha)*cos(abeta)
                dire(3) = -sin(abeta)
                orig(1) = zr(icamas+4)
                orig(2) = zr(icamas+5)
                orig(3) = zr(icamas+6)
            endif
        endif
!====
! 2. CALCULS DU TERME DE RIGIDITE DE L'OPTION
!====
!
        do kp = 1, npg
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            dtpgdx = 0.d0
            dtpgdy = 0.d0
            dtpgdz = 0.d0
            do i = 1, nno
! CALCUL DE T- ET DE SON GRADIENT
                tpg = tpg + zr(itemp+i-1)*zr(ivf+l+i-1)
                dtpgdx = dtpgdx + zr(itemp+i-1)*dfdx(i)
                dtpgdy = dtpgdy + zr(itemp+i-1)*dfdy(i)
                dtpgdz = dtpgdz + zr(itemp+i-1)*dfdz(i)
            end do
!
            if (.not.aniso) then
                tpgbuf = tpg
                call rcfode(ifon(2), tpgbuf, lambda, r8bid)
                fluglo(1) = lambda*dtpgdx
                fluglo(2) = lambda*dtpgdy
                fluglo(3) = lambda*dtpgdz
            else
! ---       TRAITEMENT DE L ANISOTROPIE
!
                tpgbuf = tpg
                call rcfode(ifon(4), tpgbuf, lambor(1), r8bid)
                call rcfode(ifon(5), tpgbuf, lambor(2), r8bid)
                call rcfode(ifon(6), tpgbuf, lambor(3), r8bid)
                if (.not.global) then
                    point(1) = 0.d0
                    point(2) = 0.d0
                    point(3) = 0.d0
                    do nuno = 1, nno
                        point(1) = point(1) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-3)
                        point(2) = point(2) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-2)
                        point(3) = point(3) + zr(ivf+l+nuno-1)* zr(igeom+ 3*nuno-1)
                    end do
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
            do i = 1, nno
                zr(ivectt+i-1) = zr(ivectt+i-1) - poids* (1.0d0-theta) *&
                                 & (dfdx(i)*fluglo(1)+dfdy(i)*fluglo(2)+dfdz(i)*fluglo(3))
                zr(ivecti+i-1) = zr(ivecti+i-1) - poids* (1.0d0-theta) *&
                                 & (dfdx(i)*fluglo(1)+dfdy(i)*fluglo(2)+dfdz(i)*fluglo(3))
            end do
! FIN BOUCLE SUR LES PTS DE GAUSS
        end do
!
!====
! 3. CALCULS DU TERME DE MASSE DE L'OPTION
!====
!
!
        do kp = 1, npg2
            l = (kp-1)*nno
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            do i = 1, nno
! CALCUL DE T- ET DE SON GRADIENT
                tpg = tpg + zr(itemp+i-1)*zr(ivf2+l+i-1)
            end do
!
! CALCUL DES CARACTERISTIQUES MATERIAUX EN TRANSITOIRE UNIQUEMENT
! ON LES EVALUE AVEC TPG=T-
            tpgbuf = tpg
            call rcfode(ifon(1), tpgbuf, beta, dbeta)
            if (lhyd) then
! THER_HYDR
                do i = 1, nno
                    zr(ivectt+i-1) = zr(ivectt+i-1) + poids*&
                                     & ((beta     -chal(1)*hydrpg(kp))*zr(ivf2+l+i-1)/deltat)
                    zr(ivecti+i-1) = zr(ivecti+i-1) + poids*&
                                     & ((dbeta*tpg-chal(1)*hydrpg(kp))*zr(ivf2+l+i-1)/deltat)
                end do
            else
! THER_NL
!
! CALCUL STD A 2 OUTPUTS (LE DEUXIEME NE SERT QUE POUR LA PREDICTION)
!
                do i = 1, nno
                    zr(ivectt+i-1) = zr(ivectt+i-1) + poids*beta /deltat*zr(ivf2+l+i-1)
                    zr(ivecti+i-1) = zr(ivecti+i-1) + poids*dbeta*tpg/deltat*zr(ivf2+l+i-1)
                end do
!
! ENDIF THER_HYDR
            endif
! FIN BOUCLE SUR LES PTS DE GAUSS
        end do
!
! --- SECHAGE
!
    else if ((zk16(icomp) (1:5).eq.'SECH_')) then
        if (zk16(icomp) (1:12) .eq. 'SECH_GRANGER' .or. zk16(icomp) (1: 10) .eq.&
            'SECH_NAPPE') then
            call jevech('PTMPCHI', 'L', isechi)
            call jevech('PTMPCHF', 'L', isechf)
        else
!          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
!          ISECHI ET ISECHF SONT FICTIFS
            isechi = itemp
            isechf = itemp
        endif
        do kp = 1, npg
            l = nno*(kp-1)
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            dtpgdx = 0.d0
            dtpgdy = 0.d0
            dtpgdz = 0.d0
            tpsec = 0.d0
            do i = 1, nno
                tpg = tpg + zr( itemp+i-1)*zr(ivf+l+i-1)
                tpsec = tpsec + zr(isechi+i-1)*zr(ivf+l+i-1)
                dtpgdx = dtpgdx + zr(itemp+i-1)*dfdx(i)
                dtpgdy = dtpgdy + zr(itemp+i-1)*dfdy(i)
                dtpgdz = dtpgdz + zr(itemp+i-1)*dfdz(i)
            end do
            call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
!
            do i = 1, nno
                zr(ivectt+i-1) = zr(ivectt+i-1) - poids* ( (1.0d0- theta)*diff*&
                                 & (dfdx(i)*dtpgdx+dfdy(i)*dtpgdy+dfdz(i)* dtpgdz) )
                zr(ivecti+i-1) = zr(ivectt+i-1)
            end do
        end do
        do kp = 1, npg2
            l = nno*(kp-1)
            call dfdm3d(nno, kp, ipoid2, idfde2, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
            tpg = 0.d0
            dtpgdx = 0.d0
            dtpgdy = 0.d0
            dtpgdz = 0.d0
            tpsec = 0.d0
            do i = 1, nno
                tpg = tpg + zr( itemp+i-1)*zr(ivf2+l+i-1)
                tpsec = tpsec + zr(isechi+i-1)*zr(ivf2+l+i-1)
                dtpgdx = dtpgdx + zr(itemp+i-1)*dfdx(i)
                dtpgdy = dtpgdy + zr(itemp+i-1)*dfdy(i)
                dtpgdz = dtpgdz + zr(itemp+i-1)*dfdz(i)
            end do
            call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
            do i = 1, nno
                zr(ivectt+i-1) = zr(ivectt+i-1) + poids* (tpg/deltat*zr(ivf2+l+i-1))
                zr(ivecti+i-1) = zr(ivectt+i-1)
            end do
        end do
!
    endif
! FIN ------------------------------------------------------------------
end subroutine
