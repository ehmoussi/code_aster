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

subroutine dglrdm()
    implicit none
!
! person_in_charge: sebastien.fayolle at edf.fr
! ----------------------------------------------------------------------
!
! BUT : DETERMINATION DES PARAMETRES MATERIAU POUR LE MODELE GLRC_DM
!
! IN:
!       LOI     : LOI DE COMPORTEMENT DE PLAQUE BETON ARME (GLRC_DM OU
!                 GLRC_DAMAGE)
!       IMATE   : ADRESSE DU MATERIAU (ACIER ET BETON)
!       COMPOR  : COMPORTMENT
!       EP      : EPAISSEUR DE LA PLAQUE
!       OMY     : SECTION D'ACIER D'UN LIT DE CABLES SUIVANT Y (M²/ML)
!       OMX     : SECTION D'ACIER D'UN LIT DE CABLES SUIVANT X (M²/ML)
!       RY      : POSITION ADIMENSIONNEE DU LIT DE CABLES SUIVANT Y
!       RX      : POSITION ADIMENSIONNEE DU LIT DE CABLES SUIVANT X
!       METHODE_ENDO : CHOIX DE LA METHODE DE CALCUL DE L'ENDOMMAGEMENT
!                 "ENDO_NAISS" : ON CONSIDERE UNE EVOLUTION
!                 INFINITESIMALE JUSTE APRES APPARITION DU PREMIER
!                 ENDOMMAGEMENT
!                 "ENDO_LIM"   : ON CONSIDERE DES ENDOMMAGMENTS
!                                IMPORTANTS
!                 "ENDO_INT"   : ON CALCULE LE RAPPORT
!                                PENTE D'ENDOMMAGEMENT/PENTE ELASTIQUE
!       PENTE/TRACTION : METHODE RETENUE POUR CALCULER LA PENTE D'ENDOMMAGEMENT
!                 "ACIER_PLAS"     = RECALAGE A LA PLASTICITE DES ACIERS
!                 "UTIL" = RECALAGE A LA DEFO GENE MAX DE L'ELEMENT
!                 "RIGI_ACIER"= PENTE REPRISE DES RAIDEURS DES ACIERS
!       PENTE/FLEXION : METHODE RETENUE POUR CALCULER LA PENTE D'ENDOMMAGEMENT
!                 "UTIL" = RECALAGE A LA DEFO GENE MAX DE L'ELEMENT
!                 "RIGI_INIT"= RECALAGE AU DEBUT PHASE NON LINEAIRE
!                 "RIGI_ACIER"= PENTE REPRISE DES ACIERS

!       CISAIL  : RECALAGE PAR RAPPORT AU TEST DE CISAILLEMENT PUR
!       INFO    : IMPRESSION DES PARAMETRES DE LA LOI GLRC_DM
! OUT:
!       RHO     : MASSE VOLUMIQUE DE LA STRUCTURE
!       AMORA   : AMORTISSEMENT ALPHA
!       AMORB   : AMORTISSEMENT BETA
!       EM      : PARAMETRE D ELASTICITE - MEMBRANE
!       NUM     : PARAMETRE D ELASTICITE - MEMBRANE
!       EF      : PARAMETRE D ELASTICITE - FLEXION
!       NUF     : PARAMETRE D ELASTICITE - FLEXION
!       GT      : PARAMETRE GAMMA POUR LA MEMBRANE EN TRACTION
!       GC      : PARAMETRE GAMMA POUR LA MEMBRANE EN COMPRESSION
!       GF      : PARAMETRE GAMMA POUR LA FLEXION
!       NYT     : SEUIL D'ENDOMMAGEMENT EN TRACTION
!       NYC     : SEUIL D'ENDOMMAGEMENT EN COMPRESSION
!       MYF     : SEUIL D'ENDOMMAGEMENT EN FLEXION
!       ALPHAC  :
!       EPSI_C  :
! ----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/dgelas.h"
#include "asterfort/dgendo.h"
#include "asterfort/dgplas.h"
#include "asterfort/dgseui.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/rcvale.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: na
    parameter (na=10)
    integer :: nnap, ibid, ilit, jlm, jmelk
    integer :: jmelr, jmelc, lonobj
    integer :: iret, icisai
    integer :: ibid1, ibid2
    integer :: nimpr, impr, ifr, ipentetrac, nalphat, ipenteflex
!
    real(kind=8) :: ea(3*na), sya(3*na), eb, nub, b, b1, a
    real(kind=8) :: h, np, emaxm, kapflex, alphat
    real(kind=8) :: pendt, pendf, nyc, gt, gf, gc
    real(kind=8) :: num, nuf, em, ef, nyt, dxd, myf, dxp, drp, mp, rho, drd
    real(kind=8) :: pelast, pelasf, amora, amorb, amorh, rhob, rhoa, alpha, beta, hyst
    real(kind=8) :: omx(3*na), omy(3*na)
    real(kind=8) :: rx(3*na), ry(3*na)
    real(kind=8) :: valres(6), r8b
    real(kind=8) :: epsi_c, fcj, ftj, alpha_c, epsi_els, epsi_lim
!
    integer :: icodr2(6)
    character(len=6) :: k6
    character(len=8) :: mater, k8b
    character(len=16) :: nomres(6)
    character(len=19) :: cisail, pentetrac, penteflex
    character(len=16) :: type, nomcmd, fichie
!
    call jemarq()
!
    nnap = 1
    a=0.d0
    b=0.d0
    b1=0.d0
!
! - VARIABLE D IMPRESSION DES PARAMETRES GLRC_DM
    nimpr = 0
    call getvis(' ', 'INFO', scal=impr, nbret=ibid1)
    if (impr .eq. 2) then
        nimpr = 1
        ifr = iunifi('RESULTAT')
        fichie = ' '
        if (.not. ulexis( impr )) then
            call ulopen(impr, ' ', fichie, 'NEW', 'O')
        endif
    endif
!
! - RELEVE DES CARACTERISTIQUES DU BETON
    call getvid('BETON', 'MATER', iocc=1, scal=mater, nbret=ibid)
    nomres(1) = 'E'
    nomres(2) = 'NU'
    nomres(3) = 'RHO'
    nomres(4) = 'AMOR_ALPHA'
    nomres(5) = 'AMOR_BETA'
    nomres(6) = 'AMOR_HYST'
    k8b = ' '
    r8b = 0.d0
!
    call getvr8('BETON', 'EPAIS', iocc=1, scal=h, nbret=ibid)
!
    call rcvale(mater, 'ELAS      ', 0, k8b, [r8b], 6, nomres, valres, icodr2, 0)
!
    if (icodr2(1) .ne. 0 .or. icodr2(2) .ne. 0) then
        call utmess('A', 'ALGORITH6_8')
    endif
!
    eb = valres(1)
    nub = valres(2)
    rhob = valres(3)
!
    if (icodr2(4) .ne. 0) then
        amora = 0.0d0
    else
        amora = valres(4)
    endif
    if (icodr2(5) .ne. 0) then
        amorb = 0.0d0
    else
        amorb = valres(5)
    endif
    if (icodr2(6) .ne. 0) then
        amorh = 0.0d0
    else
        amorh = valres(6)
    endif

    nomres(1) = 'FCJ'
    nomres(2) = 'EPSI_C'
    nomres(3) = 'FTJ'
    call rcvale(mater, 'BETON_GLRC ', 0, k8b, [r8b], 3, nomres, valres, icodr2, 0)
    if (icodr2(1) .ne. 0 .or. icodr2(2) .ne. 0 .or. icodr2(3) .ne. 0) then
        call utmess('F', 'ALGORITH6_38')
    endif
    fcj = valres(1)
    epsi_c = valres(2)
    ftj = valres(3)
    if (fcj.lt. ftj) then
        call utmess('F', 'ALGORITH6_2')
    endif

! DEFINITION DES PROPRIETES MECANIQUE DU FERRAILLAGE
!      IF(NNAP .GT. 0) THEN
!        DO 10, ILIT = 1,NNAP
    ilit = 1
    call getvid('NAPPE', 'MATER', iocc=ilit, scal=mater, nbret=ibid)
    nomres(1) = 'E'
    nomres(2) = 'NU'
    nomres(3) = 'RHO'
!
    call rcvale(mater, 'ELAS            ', 0, k8b, [r8b], 3, nomres, valres, icodr2, 0)
!
    if (icodr2(1) .ne. 0 .or. icodr2(2) .ne. 0) then
        call utmess('A', 'ALGORITH6_10')
    endif
    ea(ilit) = valres(1)
!         NUA(ILIT)=VALRES(2) ON NE PREND PAS EN COMPTE L EFFET DE
!         POISSON SUR LES ARMATURES
    rhoa = valres(3)
!
    nomres(1) = 'SY'
    nomres(2) = 'SIGM_LIM'
    nomres(3) = 'EPSI_LIM'
    call rcvale(mater, 'ECRO_LINE       ', 0, k8b, [r8b],&
                3, nomres, valres, icodr2, 0)
!
    if (icodr2(1) .eq. 0) then
        sya(ilit) = valres(1)
    else
        sya(ilit) = -1.d0
    endif
    if (icodr2(2) .ne. 0 .or. icodr2(3) .ne. 0)then
        call utmess('F', 'ALGORITH6_37')
    endif
    epsi_els = valres(2)/ea(1)
    epsi_lim = valres(3)
!
    call getvr8('NAPPE', 'OMX', iocc=ilit, scal=omx(ilit), nbret=ibid)
    call getvr8('NAPPE', 'OMY', iocc=ilit, scal=omy(ilit), nbret=ibid)
    call getvr8('NAPPE', 'RX',  iocc=ilit, scal=rx(ilit),  nbret=ibid)
    call getvr8('NAPPE', 'RY',  iocc=ilit, scal=ry(ilit),  nbret=ibid)
    if ((omx(ilit) .ne. omy(ilit)) .or. (rx(ilit) .ne. ry(ilit))) then
        call utmess('A', 'ALGORITH6_6')
    endif
! Mise en cohérence avec GLRC_DAMAGE
! Développement fait pour -0.5<RX<0.5
! or pour la cohérence avec GLRC_DAMAGE
! on se met dans le cas -1<RX<1
! pour repasser dans les conditions initiale on multiplie RX par 1/2
    rx(ilit)=rx(ilit)*0.5d0
    ry(ilit)=ry(ilit)*0.5d0
! Fin mise en cohérence avec GLRC_DAMAGE
!
    b=ea(ilit)*(omx(ilit)+omy(ilit))
! B1=B1+EA(ILIT)*(RX(ILIT)+RY(ILIT))/2.*(OMX(ILIT)+OMY(ILIT))
! B1 = 0 du à la symétrie de la plaque
    b1=0.d0
    a=ea(ilit)*(omx(ilit)+omy(ilit))*((rx(ilit)+ry(ilit))/2.d0)**2
! 10     CONTINUE
!      ENDIF
! RECUPARATION DE LA MASSE VOLUMIQUE EQUIVALENTE ET DES COEFFICIENTS
! D'AMORTISSEMENT DE RAYLEIGH
!
! ATTENTION CA NE FONCTIONNE PAS SI ON A PLUSIEURS ARMATURES
    call getvr8(' ', 'RHO', scal=rho, nbret=iret)
    if (iret .eq. 0) then
        rho=rhob + rhoa/h*2.d0*(omx(1)+omy(1))
    endif
    alpha = 0.d0
    beta  = 0.d0
    hyst  = 0.d0
    call getvr8(' ', 'AMOR_ALPHA', scal=alpha, nbret=ibid1)
    if (ibid1 .eq. 0) then
        alpha=amora
    endif
    call getvr8(' ', 'AMOR_BETA', scal=beta, nbret=ibid1)
    if (ibid1 .eq. 0) then
        beta=amorb
    endif
    call getvr8(' ', 'AMOR_HYST', scal=hyst, nbret=ibid1)
    if (ibid1 .eq. 0) then
        hyst=amorh
    endif
!
! RECUPERATION DES MOTS CLES "CISAIL" et "PENTE"

!   PENTE/TRACTION
    call getvtx('PENTE', 'TRACTION', iocc=1, scal=pentetrac, nbret=ibid1)

    if (pentetrac .eq. 'UTIL') then
        ipentetrac = 3
        call getvr8('PENTE', 'EPSI_MEMB',  iocc=1, scal=emaxm, nbret=ibid1)
    else if (pentetrac .eq. 'PLAS_ACIER') then
        if (sya(ilit) .le. 0.d0) then
            call utmess('F', 'ALGORITH6_11')
        endif
        ipentetrac = 2
    else if (pentetrac .eq. 'RIGI_ACIER') then
        ipentetrac = 1
    endif

!   PENTE/FLEXION
    call getvtx('PENTE', 'FLEXION', iocc=1, scal=penteflex, nbret=ibid1)
    kapflex = 0.d0
    if (penteflex.eq.'UTIL')then
        call getvr8('PENTE', 'KAPPA_FLEX', iocc=1, scal=kapflex, nbret=ibid1)
        ipenteflex = 2
    else if (penteflex .eq. 'RIGI_ACIER') then
        ipenteflex = 3
    else if (penteflex .eq. 'PLAS_ACIER') then
        ipenteflex = 4
    else
        ipenteflex = 1
    endif
!
    call getvtx(' ', 'CISAIL', scal=cisail, nbret=ibid2)
    if (cisail .eq. 'OUI') then
        icisai = 1
    else
        icisai = 0
    endif
!
! - CALCUL DES PARAMETRES ELASTIQUE HOMOGENEISES EM,NUM,EF,NUF
    call getres(mater, type, nomcmd)
    call dgelas(eb, nub, h, b, a, em, num, ef, nuf, icisai)
! - DETERMINATION DES POINTS DE FISSURATION (DXD,NYT) ET (DRD,MYF)
!   ET DES PENTES ELASTIQUES
    call dgseui(em, num, ef, nuf, eb, nub, ftj, h, icisai, nyt, dxd, myf, drd, pelast,&
                pelasf)
! - DETERMINATION DES PENTES POST ELASTIQUE
    call dgplas(ea, sya, eb, nub, ftj, fcj, num, nuf, a, b1, b, nyt, myf, ef, dxd, drd, h,&
                ipentetrac, ipenteflex, icisai, emaxm, kapflex, nnap, omx(1), rx, ry,&
                np, dxp, pendt,drp, mp, pendf)
! - DETERMINATION DES PARAMETRES D ENDOMMAGEMENT
    call dgendo(em, h, ea(1), sya(1), fcj, epsi_c, &
                nyt, nyc, num, pendt, pendf, pelast, pelasf,&
                icisai, gt, gf, gc, ipentetrac,&
                np, dxp, b,alpha_c)
!---------------------------------------------------------------------------------------

!-----REMPLISSAGE DU MATERIAU
    call wkvect(mater//'.MATERIAU.NOMRC ', 'G V K32', 2, jlm)
    zk32(jlm ) = 'GLRC_DM'
    zk32(jlm+1) = 'ELAS_GLRC'

!---------ELASTIQUE---------------
    lonobj = 9
    call codent(2,'D0',K6)
    call wkvect(mater//'.CPT.'//K6//'.VALK', 'G V K16', 2*lonobj, jmelk)
    call jeecra(mater//'.CPT.'//K6//'.VALK', 'LONUTI',   lonobj)
    call wkvect(mater//'.CPT.'//K6//'.VALR', 'G V R',    lonobj, jmelr)
    call jeecra(mater//'.CPT.'//K6//'.VALR', 'LONUTI',   lonobj)
    call wkvect(mater//'.CPT.'//K6//'.VALC', 'G V C',    lonobj, jmelc)
    call jeecra(mater//'.CPT.'//K6//'.VALC', 'LONUTI',   0)
    zk16(jmelk ) = 'E_M     '
    zr(jmelr ) = em
    zk16(jmelk+1) = 'NU_M    '
    zr(jmelr+1 ) = num
    zk16(jmelk+2 ) = 'E_F     '
    zr(jmelr+2 ) = ef
    zk16(jmelk+3) = 'NU_F    '
    zr(jmelr+3 ) = nuf
    zk16(jmelk+4) = 'RHO     '
    zr(jmelr+4 ) = rho
    if (alpha .gt. 0.0d0) then
        zk16(jmelk+5) = 'AMOR_ALPHA'
        zr(jmelr+5 ) = alpha
    endif
    if (beta .gt. 0.0d0) then
        zk16(jmelk+6) = 'AMOR_BETA'
        zr(jmelr+6 ) = beta
    endif
    if (hyst .gt. 0.0d0) then
        zk16(jmelk+7) = 'AMOR_HYST'
        zr(jmelr+7 ) = hyst
    endif

!   -- alphat : coef. dilatation thermique :
    call getvr8(' ', 'ALPHA', iocc=1, scal=alphat, nbret=nalphat)
    if (nalphat .eq. 1) then
        zk16(jmelk+8) = 'ALPHA'
        zr(jmelr+8 ) = alphat
    endif

!---------GLRC_DM---------------
    lonobj = 16
    call codent(1,'D0',K6)
    call wkvect(mater//'.CPT.'//K6//'.VALK', 'G V K16', 2*lonobj, jmelk)
    call jeecra(mater//'.CPT.'//K6//'.VALK', 'LONUTI',   lonobj)
    call wkvect(mater//'.CPT.'//K6//'.VALR', 'G V R',    lonobj, jmelr)
    call jeecra(mater//'.CPT.'//K6//'.VALR', 'LONUTI',   lonobj)
    call wkvect(mater//'.CPT.'//K6//'.VALC', 'G V C',    lonobj, jmelc)
    call jeecra(mater//'.CPT.'//K6//'.VALC', 'LONUTI',   0)
    zk16(jmelk)   = 'GAMMA_T '
    zr(jmelr )   = gt
    zk16(jmelk+1) = 'GAMMA_F '
    zr(jmelr+1 ) = gf
    zk16(jmelk+2) = 'GAMMA_C '
    zr(jmelr+2 ) = gc
    zk16(jmelk+3) = 'NYT     '
    zr(jmelr+3 ) = nyt
    zk16(jmelk+4) = 'MYF     '
    zr(jmelr+4 ) = myf
    zk16(jmelk+5) = 'NYC     '
    zr(jmelr+5 ) = nyc
    zk16(jmelk+6) = 'ALPHA_C '
    zr(jmelr+6 ) = alpha_c
    zk16(jmelk+7) = 'EPSI_C  '
    zr(jmelr+7 ) = epsi_c
    zk16(jmelk+8) = 'EPSI_ELS'
    zr(jmelr+8 ) = epsi_els
    zk16(jmelk+9) = 'EPSI_LIM'
    zr(jmelr+9 ) = epsi_lim
    zk16(jmelk+10) = 'RX'
    zr(jmelr+10 ) = rx(1)/2.d0
    zk16(jmelk+11) = 'OMX'
    zr(jmelr+11 ) = omx(1)
    zk16(jmelk+12) = 'EA'
    zr(jmelr+12 ) = ea(1)
    zk16(jmelk+13) = 'SY'
    zr(jmelr+13 ) = sya(1)
    zk16(jmelk+14) = 'FTJ'
    zr(jmelr+14 ) = ftj
    zk16(jmelk+15) = 'FCJ'
    zr(jmelr+15 ) = fcj

!---------IMPRESSION-------------
    if (nimpr .gt. 0) then
        write (ifr,*) 'PARAMETRES HOMOGENEISES POUR GLRC_DM :'
        write (ifr,*) 'PENTE EN TRACTION = :',pentetrac
        write (ifr,*) 'PENTE EN FLEXION = :',penteflex
        write (ifr,*) 'CISAILLEMENT = :',cisail
        write (ifr,*) 'MODULE D YOUNG ET COEFFICIENT DE POISSON EFFECTIFS EN MEMBRANE:'
        write (ifr,*) 'E_M =  :',em
        write (ifr,*) 'NU_M =  :',num
        write (ifr,*) 'MODULE D YOUNG ET COEFFICIENT DE POISSON EFFECTIFS EN FLEXION:'
        write (ifr,*) 'E_F =  :',ef
        write (ifr,*) 'NU_F =  :',nuf
        write (ifr,*) 'LIMITES ELASTIQUES EN TRACTION, FLEXION ET COMPRESSION :'
        write (ifr,*) 'NYT =   :',nyt
        write (ifr,*) 'MYF =   :',myf
        write (ifr,*) 'NYC =   :',nyc
        write (ifr,*) 'PARAMETRES D ENDOMMAGEMENT:'
        write (ifr,*) 'GAMMA_T = ',gt
        write (ifr,*) 'GAMMA_F = ',gf
        write (ifr,*) 'GAMMA_C = ',gc
        write (ifr,*) 'ALPHA_C = ',alpha_c
        write (ifr,*) 'PARAMETRES DE DEFORMATION:'
        write (ifr,*) 'EPSI_C   = ',epsi_c
        write (ifr,*) 'EPSI_ELS = ',epsi_els
        write (ifr,*) 'EPSI_LIM = ',epsi_lim
        write (ifr,*) 'MASSE VOLUMIQUE:'
        write (ifr,*) 'RHO = ',rho
        if (alpha .gt. 0.0d0 .or. beta .gt. 0.0d0 .or. hyst .gt. 0.0d0) then
            write (ifr,*) 'PARAMETRES D AMORTISSEMENT:'
            write (ifr,*) 'AMOR_ALPHA:',alpha
            write (ifr,*) 'AMOR_BETA:',beta
            write (ifr,*) 'AMOR_HYST:',hyst
        endif
    endif
    call jedema()
end subroutine
