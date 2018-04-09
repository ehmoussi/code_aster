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

subroutine def3d(ppas,tdef,nrjd,tref0,def0,sr1,srsdef,teta1,dt,&
      vdef00,def1,vdef1,CNa,nrjp,ttrd,tfid,ttdd,tdid,exmd,exnd,&
      cnab,cnak,ssad,At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!    sous programme de calcul de l avancement chimique de DEF


! ********************************************************************
implicit none
#include "asterf_types.h"
#include "asterc/r8prem.h"
! ********************************************************************

      aster_logical ::  ppas
      real(kind=8) :: teta1, dt, vdef00, def1, vdef1
      real(kind=8) :: tdef,nrjd,tref0,def0,sr1,srsdef,temp1      
      real(kind=8) :: CNa,CNamin1
      real(kind=8) :: nrjp,ttrd,tfid,ttdd
      real(kind=8) :: tdid,exmd,exnd,cnab,cnak,ssad
      real(kind=8) :: At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F
 
! Declarations locales     
      real(kind=8) :: A1,S1
      real(kind=8) :: VMaft,VMafm,Sc,Ac
      real(kind=8) :: taudis,taupre,taufix,kfd
      real(kind=8) :: a1f,cA1,coeff1,coeff2,coeff3,coeff4
      real(kind=8) :: e200,m200,tempd,tempr
      
!      print*,"tdef,nrjd,tref0,def0,sr1,srsdef,teta1,dt"
!      print*,tdef,nrjd,tref0,def0,sr1,srsdef,teta1,dt     
!      print*,"nrjp,ttrd,tfid,ttdd"
!      print*,nrjp,ttrd,tfid,ttdd      
!      print*,"tdid,exmd,exnd,cnab,cnak,ssad"
!      print*,tdid,exmd,exnd,cnab,cnak,ssad

! Initialisation des variables locales
      
      A1 = 0.0
      S1 = 0.0
      Sc = 0.0
      Ac = 0.0
      taudis = 0.0
      taupre = 0.0
      taufix = 0.0
      kfd = 0.0
      a1f = 0.0
      cA1 = 0.0
      coeff1 = 0.0
      coeff2 = 0.0
      coeff3 = 0.0
      coeff4 = 0.0
      e200 = 0.0
      m200 = 0.0
      tempd = 0.0
      tempr = 0.0
      tref0 = 0.0
      def0 = 0.0

!     teneur en aluminium et sulfates en fonction de VDEF et SSAD
      VMaft=715.d-6
      VMafm=254.6d-6
      if(ssad.ge.3.d0) then  
!        assez de sulfates pour ne faire que de la def      
         Ac=vdef00/VMaft
         SC=ssad*Ac
      else
!        les sulfates limitent la formation de la def      
         Sc=3.d0*vdef00/VMaft
         if(ssad.gt.0.) then
            Ac=Sc/ssad
         else
           if (vdef00.eq.0.) then
             Sc=0.d0
             Ac=0.d0
           else
!            on suppose qu il y a juste assez d aluminium pour ne faire
!            que de la def           
             Ac=Sc/3.d0
           end if
         end if
       end if
!       print*,'Def3d Sc,Ac mol/m3',Sc, AC
       
!      initialisation de At,St,M1,E1,M2,E2,HG si premier pas
       if(ppas) then
!        on surcharge les variables internes pour initialiser
!        le pr chimique de la def en fonction des donnees materiaux       
         if(Sc.ge.3.d0*Ac) then
            E1=Ac
            M1=0.d0
            E2=0.d0
            M2=0.d0
            At=0.d0
            St=SC-E1
         else if (Sc.le.Ac) then
            E1=0.d0
            M1=Sc
            E2=0.d0
            M2=0.d0
            At=Ac-M1
            St=0.d0
         else
            E1=(Sc-Ac)/2.d0
            M1=(3.d0*Ac-Sc)/2.d0
            E2=0.d0
            M2=0.d0
            At=0.d0
            St=0.d0
         end if
      end if
!      print*,'Def3d:At,St,M1,E1,M2,E2'
!      print*,At,St,M1,E1,M2,E2
       
!     sulfo-aluminates destabilisable en temperature       
      A1=E1+M1+E2+M2
      S1=3.d0*(E1+E2)+M1+M2

!     calcul des coeff cinetiques pour la dissolution/ precipitation       
!     passage des temperatures en Kelvin
      temp1=teta1+273.15d0
      
!     temperature seuil de destabilisation fonction de la concentration en Na
      CNamin1=cnak
      tempd=273.15d0+ttdd/max(CNa,CNamin1)**exnd
!      print*,'CNa,CNamin1,tempd'
!      print*,CNa,CNamin1,tempd-273.15               
     
      
      if(temp1.gt.tempd) then
!      dissolution des phases sulfo alumineuse
!      coeff cinetique de dissolution precipitation
!      influence de la temperature
       coeff1=(exp(-(nrjd/8.31d0)*(1.d0/temp1-1.d0/tempd)))-1.d0
!       print*,'def3d,dissolution coeff1',coeff1
       if(coeff1.gt.0.) then
!       influence des alcalins sur la dissolution
        coeff2=exp(-CNa/Cnak)   
        taudis=tdid*coeff2/coeff1
!        print*,'taudis',taudis
!       influence des alcalins sur la fixation des alu ds les HG        
        coeff3=1.d0-exp(-CNa/Cnak)         
        taufix=tfid*coeff3/coeff1
!       rapport des temps caractéristiques        
        kfd=taufix/taudis
        if(kfd-1.lt.r8prem()) then
             kfd=0.99d0
             taufix=kfd*taudis 
        end if
!        print*,'taufix',taufix       
!       actualisation de l aluminium ds les phases sulfates
        A1F=A1*exp(-dt/taudis)
!       actualisation de l aluminium libre
        AtF=At*exp(-dt/taufix)+(A1*kfd/(kfd-1.d0))*&
        (exp(-dt/taufix)-exp(-dt/taudis))        
!       actualisation des sulfates libres
!       toutes les phases disparaissent avec la meme cinetique
!        cSE=3.d0*(E1+E2)/S1
!        cSM=(M1+M2)/S1
        StF=St+(3.d0*(E1+E2)+(M1+M2))*(1.d0-exp(-dt/taudis)) 
!       actualisation des variables internes
        cA1=A1F/A1        
        E1F=E1*cA1
        E2F=E2*cA1
        M1F=M1*cA1        
        M2F=M2*cA1
       else
        E1F=E1
        E2F=E2
        M1F=M1        
        M2F=M2
        AtF=At
        StF=St
       end if
      else
!       precipitation des phases sulfo-alumineuses
!       temprerature de reference pour la precipitation      
        tempr=ttrd+273.15d0 
!       coeff cinetique pour la precipitation
!       influence de le temperature
        coeff1=((1.d0-exp(-(nrjd/8.31d0)*(1.d0/temp1-1.d0/tempd)))/&
        (1.d0-exp(-(nrjd/8.31d0)*(1.d0/tempr-1.d0/tempd))))*&
        exp(-(nrjp/8.31d0)*(1.d0/temp1-1.d0/tempr))
!        print*,'def3d:precipitation coeff1',coeff1
!       influence de l humidite 
        if(srsdef.lt.1.d0) then    
           coeff2=exp(-(1.d0-Sr1)/(1.d0-srsdef))  
        else
           coeff2=0.d0
        end if
!       influence des alcalins
        coeff3=(1.d0-min(CNa,Cnab)/Cnab)**exmd
        coeff4=coeff1*coeff2*coeff3
        if(coeff4.gt.0.) then
!          temps caracteristique de precipitation         
           taupre=tdef/(coeff1*coeff2*coeff3)
!           print*,'taupre',taupre
!          actualisation des variables internes 
!          valeurs asymptotiques
           if((St+3.d0*E2+M2).ge.(3.d0*(At+E2+M2))) then
             E200=(At+E2+M2)
             M200=0.d0
           else if ((St+3.d0*E2+M2).le.(At+E2+M2)) then 
             E200=0.d0
             M200=St+3.d0*E2+M2
           else
             E200=((St+3.d0*E2+M2)-(At+E2+M2))/2.d0
             M200=(3.d0*(At+E2+M2)-(St+3.d0*E2+M2))/2.d0
           end if
           E2F=E200+(E2-E200)*exp(-dt/taupre)
           M2F=M200+(M2-M200)*exp(-dt/taupre)
           StF=St-3.d0*(E2F-E2)-(M2F-M2)
           AtF=At-(E2F-E2)-(M2F-M2)
           M1F=M1
           E1F=E1
        else
           E1F=E1
           E2F=E2
           M1F=M1        
           M2F=M2
           AtF=At
           StF=St  
        end if
       end if  
       
!      calcul du volume des phases neoformees
       VDEF1=E2F*VMaft+M2F*VMafm 
!       VDEF1=0.d0       
       def1=VDEF1/vdef00
!      print*, "vdef00,def1,vdef1"
!      print*,vdef00,def1,vdef1 
!      read*      

!      return
end subroutine
