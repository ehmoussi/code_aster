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

subroutine gauss3d(n,a,x,b,ngf,&
                                            err1,ipzero)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!    resolution d une systeme lineaire
!    n taille du syteme a resoudre 
!    ngf taille fixe de la matrice

! ************************************************************************
    implicit none
#include "asterfort/utmess.h"
       integer ngf,n,err1
       real(kind=8) :: a(ngf,ngf+1),b(ngf),x(ngf)
       integer ipzero(ngf)        
      
       integer i,j,k,ipmax
       real(kind=8) :: aux,s
       real(kind=8) :: pmax
       real(kind=8) :: epsilon1  
       real(kind=8), dimension(1) :: valr  
       integer, dimension(2) :: vali
       real(kind=8) :: aa(22,22),bb(22)       
        
       pmax=0.d0
       
      
       
!------sauvegarde de la matrice initiale---------
!    indispensable en cas de mise a zero de multiplicateurs
!    plastiques dans fluendo3d
       do i=1,n
        do j=1,n
         aa(i,j)=a(i,j)
        end do
        bb(i)=b(i)
       end do 
!------------------------------------------------
 

!    test taille du pb
       if (n.gt.ngf) then
            vali(1) = n
            vali(2) = ngf
            call utmess('E', 'COMPOR3_35', ni=2, vali=vali)
            err1=1
            go to 999   
       end if            
       
!    precision pivot nul
       epsilon1=1.d-16       
       
       do i=1,n
         a(i,n+1)=b(i)
       end do
       
       do i=1,n
!      recherche du pivot dmax1       
         pmax=0.d0
         ipmax=i
         do j=i,n
            if (dabs(a(j,i)).gt.pmax) then 
                pmax=dabs(a(j,i))
                ipmax=j
            end if
        end do
        if(pmax.lt.epsilon1) then
!         test pivot nul            
            call utmess('E', 'COMPOR3_36', ni=1, vali=vali, nr=1, valr=valr)
            ipzero(i)=1
            ipmax=i
            err1=1
        else
            err1=0
            ipzero(i)=0
        end if
        
!     intervertion des lignes si necessaire        
        if(ipmax.ne.i) then
            do j=1,n+1
                aux=a(i,j)
                a(i,j)=a(ipmax,j)
                a(ipmax,j)=aux
            end do
        end if
        
        if(ipzero(i).ne.1) then
!      calcul ligne i utile si pmax ne 1, si non on fait rien et on mettra l inconnue a zero
!      lors de la resolution
         do j=i+1,n+1
             a(i,j)=a(i,j)/a(i,i)
         end do
        
!      calcul des autres lignes
         do k=(i+1),n
            do j=(i+1),(n+1)
                a(k,j)=a(k,j)-a(k,i)*a(i,j)
            end do
         end do
        end if
        
!     fin de la boucle sur les lignes        
        end do

!    sortie des inconnues
       if(ipzero(n).ne.1) then
         x(n)=a(n,n+1)
       else
         x(n)=0.d0
       end if
       
       do i=(n-1),1,-1
        if(ipzero(i).ne.1) then
         s=a(i,n+1)
         do j=i+1,n
           s=s-a(i,j)*x(j)
         end do
         a(i,n+1)=s
         x(i)=s
        else
         x(i)=0.d0
        end if
       end do
       
!------recuperation de la matrice initiale---------
       do i=1,n
        do j=1,n
         a(i,j)=aa(i,j)
        end do
        b(i)=bb(i)
       end do 
!--------------------------------------------------
999   continue
end subroutine
