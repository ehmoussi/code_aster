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

subroutine bgpg3d(ppas,bg,pg,mg,phig,treps,&
                                          trepspg,epspt6,epspc6,phivg,&
                                          pglim,brgi,dpg_depsa6,dpg_depspg6,&
                                          taar,nrjg,tref0,aar0,sr1,&
                                          srsrag,teta1,dt,vrag00,aar1,&
                                          tdef,nrjd,def0,srsdef,vdef00,&
                                          def1,cna,nrjp,ttrd,tfid,ttdd,&
                                          tdid,exmd,exnd,cnab,cnak,ssad,&
                                          at,st,m1,e1,m2,e2,atf,stf,&
                                          m1f,e1f,m2f,e2f,phig0)


! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
     
!   calcul de la pression et de ses derivees / deformations anelastiques
      implicit none
!   !!! attention les "eps(4 a 6)" sont des "gama(4 a 6)" !!!!
#include "asterc/r8prem.h"
#include "asterfort/rag3d.h"  
#include "asterfort/def3d.h" 

      integer i
      real(kind=8) :: bg,pg,mg,phig,treps,trepspg,phivg,pglim,trepsa
      real(kind=8) :: dpg_depsa6(6),dpg_depspg6(6)
      real(kind=8) :: epspt6(6),epspc6(6)
      real(kind=8) :: brgi,coeff1,coeff2,dpg_depsa,dpg_depspg
      
      real(kind=8) :: taar,nrjg,tref0,aar0,sr1,srsrag,teta1,dt,vrag00,aar1
      aster_logical ::  ppas
      real(kind=8) :: vdef00, def1, vdef1
      real(kind=8) :: tdef,nrjd,def0,srsdef      
      real(kind=8) :: cna
      real(kind=8) :: nrjp,ttrd,tfid,ttdd
      real(kind=8) :: tdid,exmd,exnd,cnab,cnak,ssad
      real(kind=8) :: at,st,m1,e1,m2,e2,atf,stf,m1f,e1f,m2f,e2f,phig0

      coeff1=0.d0
      coeff2=0.d0

      if(dt.ne.0.) then
!   calcul de l avancement de la reaction et du volume de gel phig
       if (abs(vrag00).ge.r8prem()) then
         call rag3d(taar,nrjg,tref0,aar0,sr1,&
                                   srsrag,teta1,dt,vrag00,aar1,&
                                   phig) 
       else
         phig=0.d0
         aar1=0.d0
       end if   
      
!      calcul de l'avancement de la def et du volume créé
       if(vdef00.gt.0.) then
         call def3d(ppas,tdef,nrjd,tref0,def0,sr1,srsdef,teta1,dt,&
         vdef00,def1,vdef1,cna,nrjp,ttrd,tfid,ttdd,tdid,exmd,exnd,&
         cnab,cnak,ssad,at,st,m1,e1,m2,e2,atf,stf,m1f,e1f,m2f,e2f)
!        on additionne les volumes de rag et de def    
         phig=phig+vdef1
       else
         def1=0.d0
         vdef1=0.d0
         atf=0.d0
         stf=0.d0
         m1f=0.d0
         e1f=0.d0
         m2f=0.d0
         e2f=0.d0
       end if
      else
!        dt=0 donc on reprend l avancement precedemment
         aar1=aar0
         def1=def0 
         atf=at
         stf=st
         m1f=m1
         e1f=e1
         m2f=m2
         e2f=e2 
         phig=phig0           
      end if
!      si dt est a zero il nefaut recalculer que la pression
!      en reprennant phig precedent


    
!   as 26/7/14 trepsa= deformation plastique d origine meca
!   (traction localisee et compression), deduit du calcul de pression
!   le volume des fissures loclisees n est pas accessible au gel de masse 

!   calcul des ouverture de fissure meca sans gel (le gel ne se
!   decharge pas dans les fissures localisees mecaniques qui ont peu
!   de chance d etre correctement localisees / gel)
!   modif sept 2014 seul ept est jugé trop eloigne du gel
      trepsa=0.d0
      do i=1,3
!      trepsa=trepsa+dmax1(epspt6(i),0.d0)+dmax1(epspc6(i),0.d0)
         trepsa=trepsa+epspt6(i)+epspc6(i)
      end do  
      
!   calcul pression phase neoformee
       bg=brgi
      coeff1=phig-(bg*(treps-trepsa)+(1.d0-bg)*trepspg)
      coeff2=1.d0+(mg*phivg/pglim)      
      if((coeff1.gt.0.d0).and.(phig.gt.0.d0)) then
!     cas non lineaire avec remplissage proportionnel à la la pression
        pg=mg*coeff1/coeff2 
        dpg_depsa=0.d0
        dpg_depspg=-mg/coeff2
      else
        pg=0.d0
        dpg_depspg=0.d0   
        dpg_depsa=0.d0
      end if        

!   attention dp est aussi affecte par la deformation elastique
!   mais comme lors du retour elastique depse+depspa+depspg=0
!   comme depse/depsa=-1 il ne reste que dpg/depse*depse/depspg+dpg/depspg
!   donc finalement
      do i=1,6
        if(i.le.3) then
             dpg_depsa6(i)=dpg_depsa             
             dpg_depspg6(i)=dpg_depspg
        else
            dpg_depsa6(i)=0.d0
            dpg_depspg6(i)=0.d0
        end if
      end do        

!   attention il faut verifier que les derviees de pg/eps soient toutes
!   nulles si pg=0 (ici ok car alors x=0 -> x2 -> dpg_depspg=0
!   et dpg_depsa==0      
end subroutine
