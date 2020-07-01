! --------------------------------------------------------------------
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
! aslint: disable=W1504,W1306
!
subroutine nmel3d(fami  , poum  , nno   , npg  ,&
                  ipoids, ivf   , idfde ,&
                  geom  , typmod, option, imate,&
                  compor, lgpg  , carcri, depl ,&
                  angmas, sig   , vi    ,&
                  matuu , vectu , codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codere.h"
#include "asterfort/nmcpel.h"
#include "asterfort/nmgeom.h"
#include "asterfort/Behaviour_type.h"
!
character(len=*), intent(in) :: fami, poum
integer, intent(in) :: nno, npg
integer, intent(in) :: ipoids, ivf, idfde
real(kind=8), intent(in) :: geom(3, nno)
character(len=8), intent(in) :: typmod(*)
character(len=16), intent(in) :: option
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*)
real(kind=8), intent(in) :: carcri(*)
integer, intent(in) :: lgpg
real(kind=8), intent(inout) :: depl(3, nno)
real(kind=8), intent(in) :: angmas(*)
real(kind=8), intent(inout)  :: sig(6, npg), vi(lgpg, npg)
real(kind=8), intent(inout) :: matuu(*), vectu(3, nno)
integer, intent(inout) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D
!
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - Hyperelasticity
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  POIDSG  : POIDS DES POINTS DE GAUSS
! IN  VFF     : VALEUR  DES FONCTIONS DE FORME
! IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  GEOM    : COORDONEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  IMATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CARCRI  : CRITERES DE CONVERGENCE LOCAUX
! IN  DEPL    : DEPLACEMENT A PARTIR DE LA CONF DE REF
! OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
! OUT PFF     : PRODUIT DES FCT. DE FORME       AU DERNIER PT DE GAUSS
! OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
! OUT SIG     : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: ndim = 3, sz_tens = 6
    aster_logical :: grand, axi
    aster_logical :: lVect, lMatr, lSigm
    integer :: kpg, kk, m, j, j1, kl, pq, kkd
    integer :: i_node, i_dime, i_tens
    integer :: cod(npg)
    real(kind=8) :: dfdi(nno, ndim), def(sz_tens, nno, ndim)
    real(kind=8) :: pff(sz_tens, nno, nno)
    real(kind=8) :: r
    real(kind=8) :: f(3, 3), eps(6), ftf, detf
    real(kind=8) :: dsidep(6, 6), sigma(6), sigp(6)
    real(kind=8) :: poids, tmp1, tmp2
    real(kind=8), parameter :: rac2 = 1.4142135623731d0
    type(Behaviour_Integ) :: BEHinteg
    integer, parameter :: indi(sz_tens) = (/ 1 , 2 , 3 , 1 , 1 , 2 /)
    integer, parameter :: indj(sz_tens) = (/ 1 , 2 , 3 , 2 , 3 , 3 /)
    real(kind=8), parameter :: rind(sz_tens) = (/ 0.5d0 , 0.5d0 ,&
                                                  0.5d0 , sqrt(2.d0)/2.d0 ,&
                                                  sqrt(2.d0)/2.d0, sqrt(2.d0)/2.d0 /)
!
! --------------------------------------------------------------------------------------------------
!
    grand  = compor(DEFO) .eq. 'GROT_GDEP'
    axi    = ASTER_FALSE
    cod    = 0
    lSigm  = L_SIGM(option)
    lVect  = L_VECT(option)
    lMatr  = L_MATR(option)
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! - Prepare external state variables
!
    call behaviourPrepESVAElem(carcri, typmod  ,&
                               nno   , npg     , ndim ,&
                               ipoids, ivf     , idfde,&
                               geom  , BEHinteg)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        eps  = 0.d0
! ----- Kinematic - Previous strains
        call nmgeom(ndim    , nno   , axi , grand, geom,&
                    kpg     , ipoids, ivf , idfde, depl,&
                    .true._1, poids , dfdi, f    , eps ,&
                    r)
! ----- Kinematic - Product [F].[B]
        do i_node = 1, nno
            do i_dime = 1, ndim
                def(1,i_node,i_dime) = f(i_dime,1)*dfdi(i_node,1)
                def(2,i_node,i_dime) = f(i_dime,2)*dfdi(i_node,2)
                def(3,i_node,i_dime) = f(i_dime,3)*dfdi(i_node,3)
                def(4,i_node,i_dime) = (f(i_dime,1)*dfdi(i_node,2) +&
                                        f(i_dime,2)*dfdi(i_node,1))/ rac2
                def(5,i_node,i_dime) = (f(i_dime,1)*dfdi(i_node,3) +&
                                        f(i_dime,3)*dfdi(i_node,1))/ rac2
                def(6,i_node,i_dime) = (f(i_dime,2)*dfdi(i_node,3) +&
                                        f(i_dime,3)*dfdi(i_node,2))/ rac2
            end do
        end do
        if (lMatr .and. grand) then
            do i_node = 1, nno
                do m = 1, i_node
                    pff(1,i_node,m) = dfdi(i_node,1)*dfdi(m,1)
                    pff(2,i_node,m) = dfdi(i_node,2)*dfdi(m,2)
                    pff(3,i_node,m) = dfdi(i_node,3)*dfdi(m,3)
                    pff(4,i_node,m) = (dfdi(i_node,1)*dfdi(m,2) +&
                                       dfdi(i_node,2)*dfdi(m,1))/rac2
                    pff(5,i_node,m) = (dfdi(i_node,1)*dfdi(m,3) +&
                                       dfdi(i_node,3)*dfdi(m,1))/rac2
                    pff(6,i_node,m) = (dfdi(i_node,2)*dfdi(m,3) +&
                                       dfdi(i_node,3)*dfdi(m,2))/rac2
                end do
            end do
        endif
! ----- Compute behaviour
        call nmcpel(BEHinteg,&
                    fami    , kpg   , 1    , poum      , ndim  ,&
                    typmod  , angmas, imate, compor    , carcri,&
                    option  , eps   , sigma, vi(1, kpg), dsidep,&
                    cod(kpg))
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
! ----- Rigidity matrix
        if (lMatr) then
            do i_node = 1, nno
                do i_dime = 1, ndim
                    kkd = (ndim*(i_node-1)+i_dime-1) * (ndim*(i_node-1)+i_dime) /2
                    do i_tens = 1, sz_tens
                        sigp(i_tens) = 0.d0
                        sigp(i_tens) = sigp(i_tens)+def(1,i_node,i_dime)*dsidep(1,i_tens)
                        sigp(i_tens) = sigp(i_tens)+def(2,i_node,i_dime)*dsidep(2,i_tens)
                        sigp(i_tens) = sigp(i_tens)+def(3,i_node,i_dime)*dsidep(3,i_tens)
                        sigp(i_tens) = sigp(i_tens)+def(4,i_node,i_dime)*dsidep(4,i_tens)
                        sigp(i_tens) = sigp(i_tens)+def(5,i_node,i_dime)*dsidep(5,i_tens)
                        sigp(i_tens) = sigp(i_tens)+def(6,i_node,i_dime)*dsidep(6,i_tens)
                    end do
                    do j = 1, ndim
                        do m = 1, i_node
                            if (m .eq. i_node) then
                                j1 = i_dime
                            else
                                j1 = ndim
                            endif
! ------------------------- Geometric part of matrix
                            tmp1 = 0.d0
                            if (grand .and. i_dime .eq. j) then
                                tmp1 = pff(1,i_node,m)*sigma(1) + pff(2,i_node,m)*sigma(2)+&
                                       pff(3,i_node,m)*sigma(3) + pff(4,i_node,m)*sigma(4)+&
                                       pff(5,i_node,m)*sigma(5) + pff(6,i_node,m)*sigma(6)
                            endif
! ------------------------- Elastic part of matrix
                            tmp2 = def(1,m,j)*sigp(1) + def(2,m,j)*sigp(2)+&
                                   def(3,m,j)*sigp(3) + def(4,m,j)*sigp(4)+&
                                   def(5,m,j)*sigp(5) + def(6,m,j)*sigp(6)
                            if (j .le. j1) then
                                kk = kkd + ndim*(m-1)+j
                                matuu(kk) = matuu(kk) + (tmp1+tmp2)*poids
                            endif
                        end do
                    end do
                end do
            end do
        endif
! ----- Internal forces
        if (lVect) then
            do i_node = 1, nno
                do i_dime = 1, ndim
                    do i_tens = 1, sz_tens
                        vectu(i_dime,i_node) = vectu(i_dime,i_node)+&
                                               poids*def(i_tens,i_node,i_dime)*sigma(i_tens)
                    end do
                end do
            end do
        endif
! ----- Cauchy stresses
        if (lSigm) then
            if (grand) then
                detf = f(3,3)*(f(1,1)*f(2,2)-f(1,2)*f(2,1))-&
                       f(2,3)*(f(1,1)*f(3,2)-f(3,1)*f(1,2))+&
                       f(1,3)*(f(2,1)*f(3,2)-f(3,1)*f(2,2))
                do pq = 1, sz_tens
                    sig(pq, kpg) = 0.d0
                    do kl = 1, sz_tens
                        ftf = (f(indi(pq), indi(kl))*f(indj(pq), indj( kl)) +&
                               f(indi(pq), indj(kl))*f(indj(pq), indi( kl)))*rind(kl)
                        sig(pq,kpg) = sig(pq,kpg)+ ftf*sigma(kl)
                    end do
                    sig(pq,kpg) = sig(pq,kpg)/detf
                end do
            else
                do i_tens = 1, 3
                    sig(i_tens,kpg) = sigma(i_tens)
                end do
                sig(4,kpg) = sigma(4)/rac2
                sig(5,kpg) = sigma(5)/rac2
                sig(6,kpg) = sigma(6)/rac2
            endif
        endif
    end do
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
