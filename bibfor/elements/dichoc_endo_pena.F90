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

subroutine dichoc_endo_pena(option, nomte, ndim, nbt, nno,&
                       nc, ulm, dul, pgl, iret)
!
! -------------------------------------------------------------------------------
! person_in_charge:fabien.grange@edf.fr
!
!     RELATION DE COMPORTEMENT "CHOC_ENDO_PENA" : COMPORTEMENT DISCRET CHOC NON-LINEAIRE
!     CALCUL DES OPTIONS
!           FULL_MECA  RAPH_MECA   RIGI_MECA_TANG  RIGI_MECA_ELAS  FULL_MECA_ELAS
!   MATR       OUI                     OUI             OUI               OUI
!   FORC       OUI         OUI
!
! -------------------------------------------------------------------------------
!  IN
!     option   : option de calcul
!     nomte    : nom terme élémentaire
!     ndim     : dimension du problème
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     ulm      : déplacement moins dans le repère local de l'élément
!     dul      : incrément de déplacement dans le repère local de l'élément
!     pgl      : matrice de passage de global a local
!
! -------------------------------------------------------------------------------
!
    implicit none
    character(len=*)    :: option, nomte
    integer             :: ndim, nbt, nno, nc, iret
    real(kind=8)        :: ulm(12), dul(12), pgl(3, 3)
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/diraidklv.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvala.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/ut2mgl.h"
#include "asterfort/ut2mlg.h"
#include "asterfort/ut2vgl.h"
#include "asterfort/ut2vlg.h"
#include "asterfort/utpsgl.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "blas/dcopy.h"
!
! -------------------------------------------------------------------------------
!
    aster_logical :: rigi, resi
    integer :: jdc, irep, imat, ivarim, ii, ivitp, idepen, iviten, neq, igeom, ivarip
    integer :: iretlc, ifono, imatsym
    integer :: icontp, iadzi, iazk24, icompo
!
    real(kind=8) :: dvl(nno*nc), dpe(nno*nc), dve(nno*nc)
    real(kind=8) :: klv(nbt), force(3), fl(nno*nc), raide(6)
    real(kind=8) :: r8bid
    character(len=8) :: k8bid
    character(len=24) :: messak(6)
! -------------------------------------------------------------------------------
    integer, parameter  :: nbres=3
    real(kind=8)        :: valres(nbres)
    integer             :: codres(nbres)
    character(len=8)    :: nomres(nbres)
    integer             :: nbpar
    real(kind=8)        :: valpar
    character(len=8)    :: nompar
    integer             :: tecro2
!
! -------------------------------------------------------------------------------
!   Variables internes
    integer,parameter       :: nbvari=3
    real(kind=8)            :: varmo(nbvari), varpl(nbvari)
! -------------------------------------------------------------------------------
    real(kind=8) :: xl(6), xd(3), rignor, amornor_in, amornor_out, deplace, ld, seuil,seuil2
    real(kind=8) :: enfoncement_resi, enfoncement_resi_moins, enfoncement
    real(kind=8) :: ftry, vitesse
    real(kind=8) :: indic_charge, indic_charge_moins, enfoncement_max
! -------------------------------------------------------------------------------
!
    iret = 0
    rigi = (option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL')
    resi = (option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL')
!   Seulement en 3D, sur un segment, avec seulement de la translation
    if ((nomte(1:12).ne.'MECA_DIS_T_L').or.(ndim.ne.3).or.(nno.ne.2).or.(nc.ne.3)) then
        call jevech('PCOMPOR', 'L', icompo)
        messak(1) = nomte
        messak(2) = option
        messak(3) = zk16(icompo+3)
        messak(4) = zk16(icompo)
        call tecael(iadzi, iazk24)
        messak(5) = zk24(iazk24-1+3)
        call utmess('F', 'DISCRETS_22', nk=5, valk=messak)
    endif
!   Nombre de degré de liberté
    neq = nno*nc
!   Paramètres en entrée
    call jevech('PCADISK', 'L', jdc)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imat)
!
    call infdis('REPK', irep, r8bid, k8bid)
!   irep = 1 = matrice en repère global ==> passer en local
    if (irep .eq. 1) then
        if (ndim .eq. 3) then
            call utpsgl(nno, nc, pgl, zr(jdc), klv)
        else if (ndim.eq.2) then
            call ut2mgl(nno, nc, pgl, zr(jdc), klv)
        endif
    else
        call dcopy(nbt, zr(jdc), 1, klv, 1)
    endif
!   Récupération des termes diagonaux : raide = klv(i,i)
    call diraidklv(nomte,raide,klv)
!
!   Champ de vitesse
    call tecach('ONO', 'PVITPLU', 'L', iretlc, iad=ivitp)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(ivitp), dvl)
        else if (ndim.eq.2) then
            call ut2vgl(nno, nc, pgl, zr(ivitp), dvl)
        endif
    else
        dvl(:) = 0.0d0
    endif
!   Champ de déplacement d'entrainement
    call tecach('ONO', 'PDEPENT', 'L', iretlc, iad=idepen)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(idepen), dpe)
        else if (ndim.eq.2) then
            call ut2vgl(nno, nc, pgl, zr(idepen), dpe)
        endif
    else
        dpe(:) = 0.0d0
    endif
!   Champ de vitesse d'entrainement
    call tecach('ONO', 'PVITENT', 'L', iretlc, iad=iviten)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(iviten), dve)
        else if (ndim.eq.2) then
            call ut2vgl(nno, nc, pgl, zr(iviten), dve)
        endif
    else
        dve(:) = 0.d0
    endif
!
!   Variables internes
    call jevech('PVARIMR', 'L', ivarim)
    do ii = 1, nbvari
        varmo(ii) = zr(ivarim+ii-1)
    enddo
!
! -------------------------------------------------------------------------------
!   Relation de comportement de choc
!
!   Coordonnees du discret dans le repère local
    xl(:) = 0.0
    if (ndim .eq. 3) then
        call utpvgl(nno, 3, pgl, zr(igeom), xl)
    else if (ndim.eq.2) then
        call ut2vgl(nno, 2, pgl, zr(igeom), xl)
    endif
!
!   Caractéristiques du matériau
    nbpar  = 0; nompar = ' '; valpar = 0.d0
    valres(:) = 0.0; nomres(:)= ' '
    nomres(1)= 'DIST_1'; nomres(2)= 'DIST_2'
    call rcvala(zi(imat), ' ', 'DIS_CHOC_ENDO', nbpar, nompar, &
                [valpar], 2, nomres, valres, codres, 0, nan='NON')
!
!   calcul du jeu
    if ( nno.eq.2 ) then
!       longueur du discret
        xd(1:3) = xl(1+ndim:2*ndim) - xl(1:ndim)
        ld = xd(1) - valres(1) - valres(2)
    else
        ld = valres(3) - valres(1)
    endif
!
!   recuperation variables internes t(-)
    enfoncement_max         = varmo(1)
    enfoncement_resi_moins  = varmo(2)
    indic_charge_moins      = varmo(3)
!
!   calcul de l'enfoncement
    if (resi) then
        if (nno .eq. 1) then
            deplace = ulm(1) + dul(1)
            vitesse = dvl(1)
        else
            deplace = (ulm(1+nc) + dul(1+nc) - ulm(1) - dul(1))
            vitesse = (dvl(1+nc) - dvl(1))
        endif
    else
        if (nno .eq. 1) then
            deplace = ulm(1)
            vitesse = dvl(1)
        else
            deplace = (ulm(1+nc) - ulm(1))
            vitesse = (dvl(1+nc) - dvl(1))
        endif
    endif
    enfoncement = deplace + ld
    if (enfoncement < enfoncement_max) then
        enfoncement_max = enfoncement
    endif
!
!   Type d'amortissement inclus ou exclus
    tecro2 = 0
    call rcvala(zi(imat), ' ', 'DIS_CHOC_ENDO', 0, ' ', &
                    [0.0d0], 1, ['CRIT_AMOR'], valres, codres, 1)
    tecro2 = nint( valres(1) )
!   récupération de l'effort enveloppe, de la raideur et de l'amortissement
    nomres(1)= 'FX'; nomres(2)= 'RIGI_NOR'; nomres(3)= 'AMOR_NOR'
    call rcvala(zi(imat), ' ', 'DIS_CHOC_ENDO', 1, 'DX', &
                [-enfoncement], nbres, nomres, valres, codres, 1)
    seuil  = valres(1)
!
    call rcvala(zi(imat), ' ', 'DIS_CHOC_ENDO', 1, 'DX', &
                [-enfoncement_max], nbres, nomres, valres, codres, 1)
    seuil2 = valres(1)
    rignor = valres(2)
    amornor_in  = 0.0
    amornor_out = 0.0
    if (tecro2 .eq. 1) then
        amornor_in  = valres(3)
    else if (tecro2 .eq. 2) then
        amornor_out = valres(3)
    endif

!   indic_charge [0, 1, 2] : [pas de contact, contact élastique, sur le seuil]
    if (resi) then
        force(:) = 0.0
        if (enfoncement-enfoncement_resi_moins>0) then
            force(1)     = 0.0
            indic_charge = 0.0
            enfoncement_resi = enfoncement_resi_moins
        else
            ! correction de l'enfoncement residuel (vitesse = 0)
            ftry = rignor*(enfoncement-enfoncement_resi_moins)
            if (abs(ftry).gt.seuil2) then
                enfoncement_resi = enfoncement+seuil2/rignor
            else
                enfoncement_resi = enfoncement_resi_moins
            endif
            ! limitation de f au seuil (en prenant en compte l'amortissement)
            ftry = rignor*(enfoncement-enfoncement_resi)+amornor_in*vitesse
            if (abs(ftry).ge.seuil) then
                force(1) = -seuil+amornor_out*vitesse
                indic_charge = 2.0
            else if (ftry+amornor_out*vitesse .gt. 0.d0) then
                force(1)     = 0.0
                indic_charge = 0.0
            else
                force(1)= ftry+amornor_out*vitesse
                indic_charge = 1.0
            endif
        endif
        ! stockage contrainte et efforts
        call jevech('PVECTUR', 'E', ifono)
        call jevech('PCONTPR', 'E', icontp)
        fl(:)=0.d0
        if (nno .eq. 1) then
            zr(icontp-1+1) = force(1)
            zr(icontp-1+2) = force(2)
            fl(1) = force(1)
            fl(2) = force(2)
            if (ndim .eq. 3) then
                zr(icontp-1+3) = force(3)
                fl(3)          = force(3)
            endif
        else if (nno.eq.2) then
            zr(icontp-1+1)    = force(1)
            zr(icontp-1+1+nc) = force(1)
            zr(icontp-1+2)    = force(2)
            zr(icontp-1+2+nc) = force(2)
            fl(1)    = -force(1)
            fl(1+nc) =  force(1)
            fl(2)    = -force(2)
            fl(2+nc) =  force(2)
            if (ndim .eq. 3) then
                zr(icontp-1+3)    =  force(3)
                zr(icontp-1+3+nc) =  force(3)
                fl(3)             = -force(3)
                fl(3+nc)          =  force(3)
            endif
        endif
        if (nc .ne. 2) then
            call utpvlg(nno, nc, pgl, fl, zr(ifono))
        else
            call ut2vlg(nno, nc, pgl, fl, zr(ifono))
        endif
        ! stockage variables internes
        varpl(1) = enfoncement_max
        varpl(2) = enfoncement_resi
        varpl(3) = indic_charge
        call jevech('PVARIPR', 'E', ivarip)
        if ( nno .eq. 1 ) then
            do ii = 1, nbvari
                zr(ivarip+ii-1) = varpl(ii)
            enddo
        else
            do ii = 1, nbvari
                zr(ivarip+ii-1)        = varpl(ii)
                zr(ivarip+ii-1+nbvari) = varpl(ii)
            enddo
        endif
    endif
    if (rigi) then
        call jevech('PMATUUR', 'E', imatsym)
        if (ndim .eq. 3) then
            call utpslg(nno, nc, pgl, klv, zr(imatsym))
        else if (ndim.eq.2) then
            call ut2mlg(nno, nc, pgl, klv, zr(imatsym))
        endif
    endif
  !
end subroutine
