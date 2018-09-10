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

subroutine cfluendo3d(fami, kpg, ksp, ndim, imate,&
                  compor, instam, instap, epsm,&
                  deps, sigm, vim, option,&
                  sigp, vip, typmod,&
                  dsidep, codret)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!      Ficher de base de FLUAGE ET ENDOMMAGEMENT
!=====================================================================
    implicit none
#include "asterf_types.h"
#include "asterfort/rcvarc.h"
#include "asterfort/rcvalb.h"
#include "asterfort/fluendo3d.h"
#include "asterfort/matini.h"
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"
!
!
    integer :: imate, ndim, kpg, ksp, codret, iret
    integer :: ifour,ifour11,kerre,nmatflu
    real(kind=8) :: instam, instap
    real(kind=8) :: epsm(6)
    real(kind=8) :: epsmc(6), depsc(6)
    real(kind=8) :: sigm(6), sigp(6)
    real(kind=8) :: vim(*), vip(*), tm, tp, tref
    real(kind=8) :: dsidep(6, 6)
    character(len=16) :: compor(*), option
    character(len=8) :: typmod(*)
    character(len=*) :: fami
!
! DECLARATIONS LOCALES
    character(len=8) :: nomres(55),nomres1(4)
    real(kind=8) :: valres(55), xmat(59), rbid,valres1(4)
    integer :: nvari, nstrs, mfr, i, j
    integer :: retour(55),retour1(4)
    real(kind=8) :: d(6, 6), e, nu, coef, coef1, coef2, coef3
    real(kind=8) :: zero, un, deux, rac2,var0(6),sig0(6)
!
    real(kind=8) :: hydrm, hydrp, sechp, sechm, sref, vgm, vgp
    real(kind=8) :: alpham, alphap, deps(6),teta13d,teta23d


!   variables de transfert de donnees ( a declarer suivant idvar4 et idvisc)
      integer nmat3d,nstrs3d,nvari3d,ierr1,mfr11
      integer NMATAILX,NVARFLU,NMATRAG,NVARRAG
      
    integer :: nbelas3d
      parameter (nbelas3d=4)
      parameter (NMATFLU=55)
      parameter (NMATAILX=0)
      parameter (NVARFLU=108)

!   taille du pseudo vecteur des contraintes pour fluendo3d (tjrs 6
!   en raison de son utilisation dans fludes3d qui la suppose à 6)      
      parameter (nstrs3d=6)
      
!   mettre a jour ici le nbre de parametres materiaux et variables
!   interne de l option du modele      
      parameter (NMATRAG=0)
      parameter (NVARRAG=0)


!   nombre totale de parametres et variables internes option comprise      
      parameter (nmat3d=nbelas3d+NMATFLU+NMATRAG+NMATAILX)
      parameter (nvari3d=NVARFLU+NVARRAG)

!   nbre de parametres materiaux sans les tailles des elements      
      real(kind=8) :: xmat3d(nmat3d),sig03d(6),sigf3d(6),depst3d(6)
      real(kind=8) :: var03d(nvari3d),varf3d(nvari3d),varf(nvari3d),sigf(6) 
!   indicateur d isotropie initiale
      aster_logical :: iso1,local11,end3d,fl3d 
!   temperatures debut et fin de pas , moyenne, pas de temps, volule rgi     
      real(kind=8) :: dt3d,phig3d  
     
    parameter       (nvari=108)
    integer, dimension(2) :: vali


    sig03d(:) = 0.d0
    sigf3d(:) = 0.d0
    var03d(:) = 0.d0
    varf3d(:) = 0.d0
    varf(:)   = 0.d0
    depsc(:)  = 0.d0
    epsmc(:)  = 0.d0
    xmat(:)   = 0.d0
    var0(:)   = 0.d0
    sig0(:)   = 0.d0
    sigf(:)   = 0.d0
    depst3d(:) = 0.d0
    valres1(:)=0.d0
    valres(:)=0.d0

!
! APPEL DE RCVARC POUR LE CALCUL DE LA TEMPERATURE
!
    call rcvarc('f', 'TEMP', '-', fami, kpg,&
                ksp, tm, iret)
    call rcvarc('f', 'TEMP', '+', fami, kpg,&
                ksp, tp, iret)
    call rcvarc('f', 'TEMP', 'REF', fami, kpg,&
                ksp, tref, iret)
!
! ------------------------------------------------
!!     RECUPERATION DE L HYDRATATION DEBUT DE PAS
    call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                ksp, hydrm, codret)
    if (codret .ne. 0) then
        hydrm=0.d0
        codret = 0
    endif
!!
!! ------------------------------------------------
!!     RECUPERATION DE L HYDRATATION FIN DE PAS
    call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                ksp, hydrp, codret)
    if (codret .ne. 0) then
        hydrp=0.d0
        codret = 0
    endif
!
! ------------------------------------------------
!     RECUPERATION DU SECHAGE
    call rcvarc(' ', 'SECH', '+', fami, kpg,&
                ksp, sechp, iret)
    if (iret .ne. 0) sechp=0.d0
    call rcvarc(' ', 'SECH', '-', fami, kpg,&
                ksp, sechm, iret)
    if (iret .ne. 0) sechm=0.d0
    call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                ksp, sref, iret)
    if (iret .ne. 0) sref=0.d0

!
! -----------------------------------------------
!     RECUPERATION DU VOLUME DE GEL DEBUT DE PAS
    call rcvarc(' ', 'X1', '-', fami, kpg,&
                ksp, vgm, codret)
    if (codret .ne. 0) then
        vgm=0.d0
        codret = 0
    endif
!
! ------------------------------------------------
!     RECUPERATION DU VOLUME DE GEL FIN DE PAS
    call rcvarc(' ', 'X1', '+', fami, kpg,&
                ksp, vgp, codret)
    if (codret .ne. 0) then
        vgp=0.d0
        codret = 0
    endif
!
! ------------------------------------------------
!
    nomres1(1)='E'
    nomres1(2)='NU'
    nomres1(3)='RHO'
    nomres1(4)='ALPHA'


!
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                4, nomres1, valres1, retour1, 2)
!
!
!        MODULES INSTANTANES ISOTROPES
    xmat(1) = valres1(1)
    xmat(2) = valres1(2)
    xmat(3)  = valres1(3)
    xmat(4) = valres1(4)
    alpham = valres1(4)
!
! --- EVALUATION PARAMETERES MATERIAU ELASTIQUES A T+
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                4, nomres1, valres1, retour1, 2)

    alphap = valres1(4)


!
! ------------------------------------------------------------------
! --  RETRAIT INCREMENT DE DEFORMATION DUE A LA DILATATION THERMIQUE
! ------------------------------------------------------------------
    if (ndim .eq. 2) then
        nstrs = 4
    else
        nstrs = 6
    endif

    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, 3
            depsc(i) = deps(i) - (alphap*(tp-tref)-alpham*(tm-tref))
            epsmc(i) = epsm(i) - alpham*(tm-tref)
        end do
        do i = 4, nstrs
            depsc(i) = deps(i)
            epsmc(i) = epsm(i)
        end do
    endif
!
! ------------------------------------------------------------------
! --  RECUPERATION PARAMETRES MATERIAU DU MODELE FLUENDO3D
! ------------------------------------------------------------------
!
    nomres(1) = 'HYDR'
    nomres(2) = 'HYDS'
    nomres(3) = 'RT'
    nomres(4) = 'REF'
    nomres(5) = 'RC'
    nomres(6) = 'DELT'
    nomres(7) = 'BETA'
    nomres(8) = 'EPT'
    nomres(9) = 'HRGI'
    nomres(10)= 'VVRG'
    nomres(11)= 'MRGI'
    nomres(12)= 'GFT'
    nomres(13)= 'EKFL'
    nomres(14)= 'YKSY'
    nomres(15)= 'XFLU'
    nomres(16)= 'TAUK'
    nomres(17)= 'TAUM'
    nomres(18)= 'NRJM'
    nomres(19)= 'DT80'
    nomres(20)= 'BSHR'
    nomres(21)= 'MSHR'
    nomres(22)= 'PORO'
    nomres(23)= 'VRAG'
    nomres(24)= 'VW'
    nomres(25)= 'SFLD'
    nomres(26)= 'MVGN'
    nomres(27)= 'EPC'
    nomres(28)= 'EKDC'
    nomres(29)= 'EKRG'
    nomres(30)= 'GFR'
    nomres(31)= 'BRGI'
    nomres(32)= 'KRGI'
    nomres(33)= 'TREF'
    nomres(34)= 'TSTH'
    nomres(35)= 'DFMX'
    nomres(36)= 'TAUG'
    nomres(37)= 'NRJG'
    nomres(38)= 'SRSG'
    nomres(39)= 'TRAG'
    nomres(40)= 'DIM3'
    nomres(41)= 'TDEF'
    nomres(42)= 'NRJP'
    nomres(43)= 'SRSD'
    nomres(44)= 'VDEF'
    nomres(45)= 'CNAD'
    nomres(46)= 'SSAD'
    nomres(47)= 'CNAK'
    nomres(48)= 'CNAB'
    nomres(49)= 'EXND'
    nomres(50)= 'EXMD'
    nomres(51)= 'TTDD'
    nomres(52)= 'TDID'
    nomres(53)= 'TFID'
    nomres(54)= 'NRJD'
    nomres(55)= 'TTRD'
!
    rbid = 0.d0

!
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', compor(1), 0, ' ', [rbid],&
                55, nomres, valres, retour, 0, nan='NON')
!
!
! --- ON REMPLIT XMAT DE nbelas+1 A nbelas+44
    do i = (nbelas3d+1), (nbelas3d+55)
        xmat(i) = valres(i-nbelas3d)
    end do
!
! --- VOLUME D'EAU
!
    if (abs(var03d(64)-1.d0).ge.r8prem()) then
        xmat(nbelas3d+24) = valres(24)
    else
        xmat(nbelas3d+24) = sechp
    endif
!
!-----VALEUR FIXEE PROVISOIREMENT POUR MFR
        mfr = 1
!-----------------------------------------

    if (typmod(1)(1:2) .eq. '3D') then
        ifour = 2
    else
        if (typmod(1)(1:6) .eq. 'D_PLAN') then
            ifour = -1
        else 
               ifour = 0
        endif
    endif
   if (compor(1) .eq. 'FLUA_PORO_BETON') then
        fl3d = .true.
           end3d= .false.
   else
              if (compor(1) .eq. 'ENDO_PORO_BETON') then
            fl3d = .false.
                  end3d= .true.
              else
                  fl3d = .true.
                  end3d= .true.
              endif
   endif

!    pas de temps
       dt3d=instap-instam
               
          do i=1,nmat3d
             xmat3d(i)=xmat(i)
          end do       

!    variables internes       
       if(nvari3d.ne.nvari) then
            vali(1) = nvari3d
            vali(2) = nvari
            call utmess('E', 'COMPOR3_16', ni=2, vali=vali)
            kerre=1
       end if
       do i=1,nvari3d
             var03d(i)=vim(i)
             varf3d(i)=vip(i)
       end do

!   initialisation des contraintes effectives si premier pas
      if (abs(var03d(64)-1.d0).ge.r8prem()) then

         do i=1,6
!         initialisation de l etage elastique
            if(i.le.3) then
!              on retire la pression intra poreuse au cas où
!              elle aurait été initialisée dans les vari            
                 var03d(18+i)=sig03d(i)-var03d(61)        
            else
                 var03d(18+i)=sig03d(i)
            end if
!         idem pour l etage de Kelvin
            var03d(49+i)=var03d(18+i)
         end do
!      on met l indicateur de 1er passage a 1
         varf3d(64)=1.        
       else
!     on reconduit l indicateur de 1er passage  
        varf3d(64)=var03d(64)
       end if

!    autres parametres a renseigner
!    temperature moyenne sur le pas
       teta13d=tm
       teta23d=tp
!    initialisation indicateur d erreur       
       ierr1=0
!    indicateur isostropie elastique et de resistance
       iso1=.true.
!    numero de la formulation (33 pour poreux)
       mfr11=mfr 
!    type de formulation
       ifour11=ifour  

      
!    controle de regularisation en cas d endommagement
       local11=.true.       
       rac2 = sqrt(2.d0)
         do 70 i = 1, 3
            depst3d(i) = depsc(i)
 70     continue 
         do 71 i = 4, nstrs
           depst3d(i) = depsc(i) * rac2
 71     continue  

         do 72 i = 1, 3
           sig03d(i) = sigm(i)
 72     continue 

         do 73 i = 4, nstrs
           sig03d(i) = sigm(i) / rac2
 73     continue 


phig3d=0.d0
       call fluendo3d(xmat3d,sig03d,sigf3d,depst3d,&
                      nstrs3d,var03d,varf3d,nvari3d,nbelas3d,&
                      teta13d,teta23d,dt3d,phig3d,ierr1,&
                      iso1, mfr11,end3d,fl3d,local11,&
                      ndim)

       do i=1,3
            sigp(i) = sigf3d(i)
        end do 
        do 80 i = 4, nstrs
            sigp(i) = sigf3d(i) * rac2
 80     continue  

        if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            do i=1,nvari
               vip(i) = varf3d(i)
            end do
        endif


!**********************************************************************
        if(ierr1.eq.0)then
            kerre=0 
        else
            kerre=1
        end if

      
!*********************************************************************!     

    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
!
        zero = 0.d0
        un = 1.d0
        deux = 2.d0
!
        call matini(6, 6, zero, d)
!
        e = xmat(1)
        nu = xmat(2)

        coef = un/ ((un+nu)* (un-deux*nu))
        coef1 = e* (un-nu)*coef
        coef2 = e*nu*coef
        coef3 = e/ (un+nu)

        d(1,1) = coef1
        d(1,2) = coef2
        d(1,3) = coef2

        d(2,1) = coef2
        d(2,2) = coef1
        d(2,3) = coef2

        d(3,1) = coef2
        d(3,2) = coef2
        d(3,3) = coef1

        d(4,4) = 0.5d0*coef3
        d(5,5) = 0.5d0*coef3
        d(6,6) = 0.5d0*coef3

        do 90 i = 1, nstrs
            do 100 j = 1, nstrs
               dsidep(i,j) = d(i,j)
100         continue
 90     continue
!
    endif
!
end subroutine
