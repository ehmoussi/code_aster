! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine matfluag3d(epse06,epsk06,sig06,&
                  psik,tauk,taum,&
                  deps6,dt,theta,kveve66,kvem66,kmve66,&
                  kmm66,bve6,bm6,deltam,avean,&
                  cc03,vcc33,vcc33t,vref33,vref33t)  
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   sous programme de calcul des matrices de couplage
!   du fluage par theta methode

!   !!! attention les "eps(4 a 6)" sont des "gama(4 a 6)" !!!!
      implicit none
#include "asterfort/matcc3d.h"

      real(kind=8) :: avean,aveve,deltak,deltakb
      integer i,j
      
!     pas de temps et theta de theta methode
      real(kind=8) :: dt, theta
      
!     parametres materiaux
!     souplesse du materiau elastique et increment de deformation pour
!     le fluage
      real(kind=8) :: deps6(6)
      real(kind=8) :: cc03(3),vcc33(3,3),vcc33t(3,3),vref33(3,3),vref33t(3,3)
      real(kind=8) :: cc06(6)
      
!     donnees fluage : contrainte de maxwell, deformation maxwell
!     rigidite relative kelvin, exposant non linearite maxwell, temps
!     carac kelvin, tenps carac initial maxwell
      real(kind=8) :: psik,tauk,taum,deltam

!     variables internes debut de pas
      real(kind=8) :: epse06(6),epsk06(6),sig06(6)
!     matrice de couplage du fluage
      real(kind=8) :: kveve66(6,6),kvem66(6,6),bve6(6)
      real(kind=8) :: kmve66(6,6),kmm66(6,6),bm6(6)   
      
!     variables locales
!     dissipation de reference et energie elestique de reference
!     energie elastique actuelle utilisee pour la consolidation wcc
      real(kind=8) :: epse6(6),sig6(6),epsk6(6)

      
      
!     ******************************************************************
!     construction de la matrice de couplage Kelvin Maxwell consolidant
!     ******************************************************************
!     preparation des parametres pour le pas de temps

!     ------------------------------------------------------------------
!     projection des coeffs de consolidation principaux dans la base 
!     actuelle (vref33)
      call matcc3d(cc03,vcc33,vcc33t,vref33,vref33t,cc06)
     
      do i=1,6
!       initialisation def elastique, contrainte, def kelvin      
        epse6(i)=epse06(i)
        sig6(i)=sig06(i)
        epsk6(i)=epsk06(i)
!       mise a zero des matrices de couplage       
        do j=1,6
             kveve66(i,j)=0.d0
             kvem66(i,j)=0.d0
             kmve66(i,j)=0.d0
             kmm66(i,j)=0.d0
        end do
!       mise a zero des second membres        
        bve6(i)=0.d0
        bm6(i)=0.d0
      end do
            
      continue      
!     preparation des variables pour l iteration courante
!     kelvin      
      deltakb=dt/tauk
      deltak=theta*deltakb
!     diagonale de kveve      
      aveve=1.d0+deltak*(1.d0+1.d0/psik)
!     diagonale couplage kvean     
      avean=deltak/psik 
!     le terme deltam est mis a zero car derivee de cc negligee
      deltam=0.d0      
!     construction des matrice de couplage pour le fluage
!     matrice kveve, kvem, kmve, kmm 
      do i=1,6      
!        termes diagonaux des matrices de couplage      
         kveve66(i,i)=aveve
         kvem66(i,i)=avean
         kmve66(i,i)=theta*dt/taum/cc06(i)
         kmm66(i,i)=1.d0+kmve66(i,i)
      end do
         
!     construction des seconds membres pour le fluage
      do i=1,6
!        second membre Kelvin
         bve6(i)=deltakb*(epse6(i)/psik-epsk6(i))+deltak*deps6(i)/psik      
!        second membre Maxwell
         bm6(i)=dt/taum/cc06(i)*(epse6(i)+theta*deps6(i))
      end do
end subroutine
