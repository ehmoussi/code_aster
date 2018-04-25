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

subroutine  criter3d(sig16p,bg,pg,bw,pw,&
                           rt33p,rtg33p,ref33p,rc,epicc,&
                           epleq,epspt6p,epspg6p,&
                           delta,beta,nc,ig,fg,&
                           na,fa,dpfa_ds,dgfa_ds,dpfa_dpg,&
                           dra_dl,souplesse66p,err1,depleq_dl,&
                           irr,fglim,&
                           kg,hpla,ekdc,&
                           hplg,dpfa_dr,tauc,epeqpc)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
implicit none
#include "asterfort/ecroup3d.h"
#include "asterf_types.h"
#include "asterfort/utmess.h"

     
!          sous programme de traitement des criteres
!          irr indice pour les calculs a faire suivant la situation
!          irr=0  on evalue tout les criteres
!          irr>0 on evalue que les criteres listes dans (ig(na)) en notation globale
        
!          !!! attention les "eps(4 a 6)" sont des "gama(4 a 6)" !!!!
        
        
!          etat de contrainte issu du tir visco elastique
           real(kind=8) :: sig16p(6),bg,pg,rt33p(3,3),rtg33p(3,3),ref33p(3,3),rc
           real(kind=8) :: epspt6p(6),epspg6p(6)
           real(kind=8) :: delta,beta,bw,pw
           real(kind=8) :: souplesse66p(6,6)
           real(kind=8) :: kg,hpla,ekdc,hplg,hplg1,hplg2
           integer err1,irr,ic,ia
           real(kind=8) :: tauc,rpiceff
        
        
!          gestion des contraintes principales negative pour DP(critere 10)
           real(kind=8) :: indict3(3),x3(3)
        
!          nombre de critere de plasticites, nombre de boucles a realiser dans les criteres
           integer nc,nb,i,j,k
!          critere en numerotation globale
           real(kind=8) :: fg(nc)
!          critere en numerotation reduite sur critere actif
           real(kind=8) :: fa(nc)
!          correspondante actif-global
           integer ig(nc)
!          nombre d actif
           integer na
!          derivee fonction seuil et pseudo potentiel
           real(kind=8) ::  dpfa_ds(nc,6),dgfa_ds(nc,6),dpfa_dpg(nc),dpfa_dr(nc)
!          derivee de la resistance / multiplicateur plastique
           real(kind=8) ::  dra_dl(nc)
        
!          invariants
           real(kind=8) :: sigs,sigd6(6),sigs_3,taue2,taue,taulim
        
!          contrainte capillaire
           real(kind=8) :: bwpw
        
!          gestion de la precision
           real(kind=8) :: precision1,precision2
           parameter(precision1=1.0d-8,precision2=1.0d-6)
!          parametres pour la loi de traction
           real(kind=8) :: eppc1
        
!          resistances et derivee potentiels et pseudo potentiels Rankine
           real(kind=8) :: rteff3(3),rtgeff3(3),refeff3(3)
           real(kind=8) :: drt_dep3(3),dref_dep3(3),drg_dep3(3)
           real(kind=8) :: sigmat3(3),sigmar3(3),sigmag3(3)
!          valeurs limites des criteres
           real(kind=8) :: fglim(nc)
!          derivee cisaillement / pg
           real(kind=8) :: dfc_dpg,rmin
!          ecoulement DP
           real(kind=8) :: x0,x2,rseuil,epseuil
!          variable logique activation d un critere
           aster_logical, dimension(nc) :: actifg
           aster_logical :: logdp,lrgitr3(3)
!          pseudo potentiel pour le cisaillement dilatant
           real(kind=8) :: Fp,bgpg,rt,epsmin,coeff,rceff,dr_dp,epleq
           real(kind=8) :: epeqpc,delta1,beta1,depleq_dl,epicc,sqrt3
!          fonction d importance de la contrainte de traction pour les rgi
!          derivee fonction seuil gel
           real(kind=8) :: dpfg_dpg(3),epsik
           real(kind=8), dimension(3) :: valr

           epsmin=0.d0
           bgpg=0.d0
           bwpw=0.d0
           hplg1=0.d0
           hplg2=0.d0
        
!***********************************************************************
!     calcul des contraintes intraporeuses
      bgpg=bg*pg
      bwpw=bw*pw
!     test de la coherence des pressions intra poreuses
      if((bgpg.lt.0.d0).or.(bwpw.gt.0.d0)) then
         valr(1) = bgpg
         valr(2) = bwpw
         call utmess('E', 'COMPOR3_17', nr=2, valr=valr)
         err1=1
         na=0
         go to 999 
      end if
       
      
!***********************************************************************      
!     Calcul des seuils et des directions d ecoulement pour Rankine
!     ******************************************************************      
!     Resistance  et contrainte pour les criteres de Rankine en traction
!      rmin=0.d0
      do j=1,3
!       pas d ecrouissage en traction pour eviter interaction avec
!       DRUCKER PRAGER lors de l ecrouissage (pb de convergence induit
!       a l echelle de la structure ou DP prend le dessus en traction)
        drt_dep3(j)=0.d0
!       resistance effective apres ecrouissage        
        rteff3(j)=rt33p(j,j)
!       contrainte externe provoquant la localisation        
        sigmat3(j)=(sig16p(j)-bgpg-bwpw)
      end do
      
!     ******************************************************************      
!     debut de l ecrouissage de compression pour eviter les interactions
      sqrt3=dsqrt(3.d0) 
      if(delta.ge.sqrt3) then
         call utmess('E', 'COMPOR3_18')
         err1=1
         na=0
         go to 999 
      else 
!        valeur min du criter de dp pour eviter les interaction avec rankine
         rt=dmax1(rteff3(1),rteff3(2),rteff3(3))  
!        non interaction avec rt uniaxial         
         rmin=rt*((sqrt3+delta)/(sqrt3-delta))
!        non interaction avec rt triaxial
         rmin=dmax1(rmin,(rt*3.d0*delta)/(sqrt3-delta))
!        marge pour eviter la confusion numerique         
         rmin=rmin*(1.d0+precision2)
!        test de compatibilite des criteres traction compression        
         if(rmin.gt.rc) then
            valr(1) = rt
            valr(2) = rc
            valr(3) = rmin
            call utmess('E', 'COMPOR3_19', nr=3, valr=valr)
             err1=1
             na=0
             go to 999 
         end if
      end if      
   
!     ******************************************************************
!     Resistance et contraintes
!     pour les criteres de Rankine en refermeture
      do j=1,3
         refeff3(j)=ref33p(j,j)
!        pas d ecrouissage en refermeture         
         dref_dep3(j)=0.d0
!        contraintes à considerer pour le critere         
         sigmar3(j)=sigmat3(j)
      end do

!     ******************************************************************
!     Resistance et contraintes 
!     pour les criteres de Rankine en pression intra poreuse (RGI)
!     --> le sechage s oppose au gonflement <--
      do j=1,3
!        ecrouissage de la resistance
         epsik=0.004
         if (epspg6p(j).lt.epsik) then
             hplg1=hplg
             drg_dep3(j)=(hplg1/souplesse66p(j,j))
             rtgeff3(j)=rtg33p(j,j)+(hplg1/souplesse66p(j,j))*dmax1(epspg6p(j),0.d0)
         else
             hplg1=hplg/10.
             drg_dep3(j)=(hplg1/souplesse66p(j,j))
             rtgeff3(j)=rtg33p(j,j)+(hplg/souplesse66p(j,j))*epsik+(hplg1/&
                        souplesse66p(j,j))*(epspg6p(j)-epsik)
         end if
!        contraintes à considerer pour le critere
          if(sigmat3(j).ge. 0.d0) then
            sigmag3(j)=dmax1(kg,0.d0)*pg
            dpfg_dpg(j)=dmax1(kg,0.d0)
          else
            sigmag3(j)=dmax1(kg,0.d0)*pg+sigmat3(j)
            dpfg_dpg(j)=dmax1(kg,0.d0)-bg
          end if          
      end do      

!***********************************************************************
!     test des criteres et parametrage des ecoulements actifs
!     initialisation des indicateur d activite des criteres
      do i=1,nc
         actifg(i)=.false.
      end do 
!     initialisation indicateur critere rgi
      do i=1,3   
         lrgitr3(i)=.false.
      end do
!     boucle sur les criteres      
10    continue
      if(irr.eq.0) then
!        1er passage on detecte les criteres actifs et on affecte les
!        directions d ecoulement
         na=0
         nb=nc
      else
!        sous iteration de retour radial, on evalue les criteres
!        et on affecte les directions de coulement du 1er pas      
         nb=na
      end if      
      do ic=1,nb
!       on boucle sur les criteres
        if(irr.eq.0)then
!           on passe tous les criteres possibles        
            i=ic
        else
!           on ne traite que les actifs du 1er pas  
            call utmess('E', 'COMPOR3_20')
            err1=1 
            go to 999           
            i=ig(ic)
        end if
        if (i.le.3) then
!          **** traction directe ***************************************
!          j sert  a se positionner sur un numero de contrainte
           j=i
!          critere de rankine           
           fg(i)=sigmat3(j)-rteff3(j)
           fglim(i)=(rteff3(j)*precision2)
!          laisser la priorite a la rgi au 2eme tour le cas echeant           
           if(((fg(i).gt.fglim(i)).and.(.not.lrgitr3(i)))&
             .or.(irr.gt.0)) then
!             indicateur de franchissement du critere           
              actifg(i)=.true.
!             critere  de Rankine actif
              if(irr.eq.0) then
!                increment du nbre de critere actifs
                 na=na+1
                 ia=na
              else
!                citere actif au 1er pas 
                 ia=ic
              end if
!             tableau de correspondance i global <- i actif              
              ig(ia)=i
!             stockage dans la table des criteres actifs              
              fa(ia)=fg(i) 
!             derivee de la fonction / pression de gel
              dpfa_dpg(ia)=-bg 
!             derivee de la fonction / resistance
              dpfa_dr(ia)=-1.d0
!             derivee de la resistance / multiplicateur plastique              
              dra_dl(ia)=drt_dep3(j)              
              do k=1,6
!               definition des derivees / sigma pour le critere actif
!               definition des derives du pseudi potentiel pour le critere actif
                if (k.eq.j) then 
                   dgfa_ds(ia,k)=1.d0               
                   dpfa_ds(ia,k)=1.d0            
                else               
                   dpfa_ds(ia,k)=0.d0
                   dgfa_ds(ia,k)=0.d0                     
                end if
              end do
           else
              actifg(i)=.false.           
           end if
       else if ((i.le.6).and.(i.gt.3)) then
!          **** critere de refermeture *********************************
!          j sert à se positionner sur le numero de la contrainte
           j=i-3
!          deformation de traction minimale pour activer le critere
           epsmin=precision1
           if (epspt6p(j).gt.epsmin) then
!             ce critere ne peut etre actif que si la fissure est ouverte        
              fg(i)=(-sigmar3(j))-refeff3(j)
           else
              fg(i)=0.d0
           end if            
           fglim(i)=(refeff3(j)*precision2)
           if((fg(i).gt.fglim(i)).or.(irr.gt.0)) then
!             indicateur de franchissement du critere           
              actifg(i)=.true.
!             critere  de refermeture actif
              if(irr.eq.0) then
!                increment du nbre de critere actifs
                 na=na+1
                 ia=na
              else
!                citere actif au 1er pas              
                 ia=ic
              end if
!             tableau de correspondance i global <- i actif              
              ig(ia)=i
!             stockage dans la table des criteres actifs              
              fa(ia)=fg(i)
!             derivee de la fonction / pression de gel
              dpfa_dpg(ia)=bg
!             derivee de la fonction / resistance
              dpfa_dr(ia)=-1.d0              
!             derivee de la resistance / multiplicateur plastique
              dra_dl(ia)=dref_dep3(j)
              do k=1,6
!               definition des derivees / sigma pour le critere actif
!               definition des derives du pseudi potentiel pour le critere actif
                if (k.eq.j) then   
                   dgfa_ds(ia,k)=-1.d0             
                   dpfa_ds(ia,k)=-1.d0            
                else    
                   dgfa_ds(ia,k)=0.d0                
                   dpfa_ds(ia,k)=0.d0            
                end if
              end do
           else
              actifg(i)=.false.           
           end if
       else if ((i.le.9).and.(i.gt.6)) then
!          **** critere de pression de gel *****************************
!          j sert à se positionner sur le numero de la contrainte
           j=i-6
!             la contrainte totale est inferieur a 0, la contrainte
!             effective utilisee pour calculer sigmag3 est donc ok           
!             critere en pression
              fg(i)=sigmag3(j)-rtgeff3(j)             

              if(irr.gt.0) then
!                le critere etait actif au 1er pas              
                 ia=ic
              else
!                on va tester le critere, s il est actif on stocke              
                 ia=na+1
              end if    
              fglim(i)=(rtgeff3(j)*precision2)              
              if((fg(i).gt.fglim(i)).or.(irr.gt.0)) then
!                indicateur de franchissement du critere           
                 actifg(i)=.true.              
!                tableau de correspondance i global <- i actif             
                 ig(ia)=i
                 if(irr.eq.0) then
                    na=ia
                 end if
!                stockage dans la table des criteres actifs              
                 fa(ia)=fg(i)
!                    derivee de la fonction / pression de gel                 
                     dpfa_dpg(ia)=dpfg_dpg(j)
!                    derivee de la fonction / resistance
                     dpfa_dr(ia)=-1.d0                      
!                derivee de la resistance / multiplicateur plastique 
                 dra_dl(ia)=drg_dep3(j)   
                 do k=1,6
!                  definition des derivees / sigma pour le critere actif
!                  definition des derives du pseudo potentiel pour le critere actif
                   if (k.eq.j) then      
!                     le critere est sensible a la contrainte effectivecar non limite par rt

                         dpfa_ds(ia,k)=1.d0
                         dgfa_ds(ia,k)=1.d0   
                   else               
                      dpfa_ds(ia,k)=0.d0 
                      dgfa_ds(ia,k)=0.d0                      
                   end if
                 end do
             else           
               actifg(i)=.false.
             end if

       else if ((i.le.10).and.(i.gt.9)) then
!          **** critere de cisaillement ********************************       
              logdp=.true.
!          rapport entre la resistance à la compression et au cisaillement
           coeff=(1.d0/dsqrt(3.d0)-delta/3.d0)
!          prise en compte de l ecrouissage en cisaillement pre pic
           call ecroup3d(rceff,dr_dp,rc,souplesse66p(1,1),epicc,epleq,&
           eppc1,rseuil,epseuil,rmin,hpla,ekdc,beta,rpiceff,&
           epeqpc)
!          passage en contrainte de cisaillement 
           taulim=dmax1(rceff*coeff,rc*coeff*precision2)
!          calcul des contraintes equivalentes totales
           sigs=0.d0         
           do j=1,3
!            contrainte normale apparente           
             x3(j)=dmin1((sig16p(j)-bgpg-bwpw),rteff3(j))
!             x3(j)=(sig16p(j)-bgpg-bwpw)
!            derive de la contrainte apparente / a la vraie  
             indict3(j)=1.d0 
!            trace de sigma apparente             
             sigs=sigs+x3(j)            
           end do
!          partie spherique vraie : -p           
           sigs_3=sigs/3.d0            
!          coeff de Drucker Prager pour le critere           
           delta1=delta
!          coeff de Drucker Prager pour la dilatance           
           beta1=beta
!          calcul du deviateur           
           taue2=0.d0
           do j=1,6
             if (j.le.3) then
                sigd6(j)=x3(j)-sigs_3
                taue2=taue2+sigd6(j)**2                
             else
                sigd6(j)=sig16p(j)
                taue2=taue2+2.d0*(sigd6(j)**2)
             end if
           end do
           taue=dsqrt(taue2/2.d0) 
!          fonction seuil pour drucker prager 
!          limitation de la contrainte spherique en cas de traction
           fg(i)=(taue+delta1*sigs_3)-taulim 
!          taux de cisaillement
           tauc=(taue+delta1*sigs_3)/(rpiceff*coeff)          
!          fg(i)=0.d0
!          pseudo potentiel plastique
           Fp=(taue+beta1*sigs_3)
!          initialisation d epl eq / d lambda           
           depleq_dl=0.d0           
!          test franchissement du critere 
!          stockage de la valeur limite du critere
           fglim(i)=(taulim*precision2) 
!          on active le critere que si les rgi sont deja satisfaites
!          et si la dilatance induit bien une dissipation           
           if(((fg(i).gt.fglim(i)).and.(Fp.gt.fglim(i)).and.logdp)&
               .or.(irr.gt.0)) then
!              indicateur de franchissement du critere           
               actifg(i)=.true.           
!             critere  de cisaillement actif
!             increment du nbre de critere actifs
              if(irr.eq.0) then
!                 critere de cisaillement actif au 1er passge              
                  na=na+1
                  ia=na
              else
!                 critere actif au 1er passge : on reevalue
                  ia=ic
              end if                  
!             tableau de correspondance i global <- i actif              
              ig(ia)=i
!             stockage dans la table des criteres actifs              
              fa(ia)=fg(i)
!             initialisation derivee de la fonction / pression de gel              
              dfc_dpg=0.d0
!             derivve de fg et direction de l ecoulement
              if (taue.gt.0.d0) then
                 x2=0.5d0/taue
              else
!                procedure pour eviter la division par zero lors d 'un
!                chargement triaxial de traction en l abscence de deviateur
!                on est a la pointe du critere
                 x2=0.d0
                 valr(1) = 0.5d0/taue
                 valr(2) = x2
                 call utmess('A', 'COMPOR3_21', nr=2, valr=valr)
              end if 
!             calcul des derivees dans les 6 directions              
              do k=1,6                
!               termes de la diagonale                   
                if (k.le.3) then 
                   x0=x2*sigd6(k)
!                  definition des derivees du potentiel / sigma 
                   dpfa_ds(ia,k)=(x0+delta1/3.d0)*indict3(k)
!                  definition des derives du pseudo potentiel
!                  reste non associee meme si perte de l effet du confinement
!                  sur le critere
                   dgfa_ds(ia,k)=(x0+beta1/3.d0)*indict3(k)
!                  derivee / pression de gel
                   dfc_dpg=dfc_dpg-dpfa_ds(ia,k)*bg                                               
                else 
!                  potentiel
                   x0=x2*sigd6(k)
                   dpfa_ds(ia,k)=x0
!                  direction d ecoulement             
!                  calcul de la direction de l ecoulement 
!                  gama (et pas epsilon !)                     
                   dgfa_ds(ia,k)=2.d0*x0                  
                end if
                if (k.gt.3) then
                    depleq_dl=depleq_dl+sig16p(k)*dgfa_ds(ia,k)
                else
                    depleq_dl=depleq_dl+x3(k)*dgfa_ds(ia,k)
                end if
              end do
!             derivee de la fonction / pression de gel              
              dpfa_dpg(ia)=dfc_dpg              
!             normalisation du tau d evolution de la def plastique equivalente
              depleq_dl=depleq_dl/Rceff
!             derivee de la fonction / resistance
              dpfa_dr(ia)=-1.d0              
!             derive de la resistance par rapport au multiplicateur plastique
!             on multiplie par coeff car critere en cisaillement
              dra_dl(ia)=dr_dp*depleq_dl*coeff
           else
               actifg(i)=.false. 
               if (fg(i).gt.fglim(i)) then
                    valr(1) = fg(i)
                    valr(2) = fglim(i)
                    call utmess('A', 'COMPOR3_22', nr=2, valr=valr)
               end if                
           end if
       end if
      end do
      
      go to 999       
 
!     traitement des ecoulements prioritaires en cas de rgi
      do i=1,3
        lrgitr3(i)=.false.      
        if (actifg(i).and.actifg(i+6)) then
           lrgitr3(i)=.true.
        endif
      end do
      if (lrgitr3(1).or.lrgitr3(2).or.lrgitr3(3)) then
       goto 10
!      on quitte le programme que si rt et rtg non actifs simultanement       
      end if

999  continue
end subroutine
