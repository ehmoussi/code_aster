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
!
subroutine te0431(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/cargri.h"
#include "asterfort/codere.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nmco1d.h"
#include "asterfort/nmgrib.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/lteatt.h"
#include "asterfort/tecach.h"
#include "blas/dcopy.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: GRILLE_MEMBRANE / GRILLE_EXCENTRE
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: codres(2)
    character(len=4) :: fami
    character(len=16) :: nomres(2)
    integer :: nddl, nno, nnos, npg, ndim, i, j, j1, n, m, kpg, kk, kkd, lgpg
    integer :: cod(9)
    integer :: imatuu, ipoids, ivf, idfde, igeom, imate, icontm, ivarim
    integer :: jgano, jtab(7), jcret, ideplm, ideplp, icompo, icarcr, iret
    integer :: ivectu, icontp, ivarip, ivarix, icontx
    real(kind=8) :: dff(2, 8), b(6, 8), p(3, 6), jac
    real(kind=8) :: dir11(3), densit, pgl(3, 3), distn, vecn(3)
    real(kind=8) :: epsm, deps, sigm, sig, tmp, rig, valres(2)
    real(kind=8) :: angmas(3)
    aster_logical :: lexc, lNonLine, lLine
    aster_logical :: lVect, lMatr, lVari, lSigm
    character(len=16) :: rela_cpla, rela_comp
!
! --------------------------------------------------------------------------------------------------
!

    lexc = (lteatt('MODELI','GRC'))
!
    lNonLine = (option(1:9).eq.'FULL_MECA').or.&
               (option.eq.'RAPH_MECA').or.&
               (option(1:10).eq.'RIGI_MECA_')
    lLine    = option .eq. 'RIGI_MECA'
!
! - FONCTIONS DE FORMES ET POINTS DE GAUSS
!
    fami = 'RIGI'
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    if (lLine) then
        call jevech('PMATERC', 'L', imate)
        lVect = ASTER_FALSE
        lVari = ASTER_FALSE
        lSigm = ASTER_FALSE
        rela_comp = ' '
        rela_cpla = ' '
        lMatr = ASTER_TRUE
    elseif (lNonLine) then
        call jevech('PMATERC', 'L', imate)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PCARCRI', 'L', icarcr)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PDEPLMR', 'L', ideplm)
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
        lgpg = max(jtab(6),1)*jtab(7)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PVARIMP', 'L', ivarix)
        call r8inir(3, r8nnem(), angmas, 1)
    else
        ASSERT(ASTER_FALSE)
    endif

    if (lNonLine) then
! ----- Select objects to construct from option name
        call behaviourOption(option, zk16(icompo),&
                             lMatr , lVect ,&
                             lVari , lSigm)
! ----- Properties of behaviour
        rela_comp = zk16(icompo-1+RELA_NAME)
        rela_cpla = zk16(icompo-1+PLANESTRESS)
    endif
!
! - Get output fields
!
    ivarip=1
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    endif
! - PARAMETRES EN SORTIE SUPPLEMENTAIE POUR LA METHODE IMPLEX    
    if (option .eq. 'RIGI_MECA_IMPLEX') then
        call jevech('PCONTXR', 'E', icontx)
! ------ INITIALISATION DE LA CONTRAINTE INTERPOLE CONTX=CONTM 
        call dcopy(npg, zr(icontm), 1, zr(icontx), 1)
    endif
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
!
        cod = 0
!
! - LECTURE DES CARACTERISTIQUES DE GRILLE ET
!   CALCUL DE LA DIRECTION D'ARMATURE
!
    call cargri(lexc, densit, distn, dir11)
!
! - SI EXCENTREE : RECUPERATION DE LA NORMALE ET DE L'EXCENTREMENT
!
    if (lexc) then
!
        if (nomte .eq. 'MEGCTR3') then
            call dxtpgl(zr(igeom), pgl)
        else if (nomte.eq.'MEGCQU4') then
            call dxqpgl(zr(igeom), pgl, 'S', iret)
        endif
!
        do i = 1, 3
            vecn(i)=distn*pgl(3,i)
        enddo
        nddl=6
!
    else
        nddl = 3
    endif
!
! - DEBUT DE LA BOUCLE SUR LES POINTS DE GAUSS
!
    do kpg = 1, npg
!
! --- MISE SOUS FORME DE TABLEAU DES VALEURS DES FONCTIONS DE FORME
!     ET DES DERIVEES DE FONCTION DE FORME
!
        do n = 1, nno
            dff(1,n)=zr(idfde+(kpg-1)*nno*2+(n-1)*2)
            dff(2,n)=zr(idfde+(kpg-1)*nno*2+(n-1)*2+1)
        enddo
!
! --- CALCUL DE LA MATRICE "B" : DEPL NODAL --> EPS11 ET DU JACOBIEN
!
        call nmgrib(nno, zr(igeom), dff, dir11, lexc,&
                    vecn, b, jac, p)
!
! --- RIGI_MECA : ON DONNE LA RIGIDITE ELASTIQUE
!
        if (lLine) then
            nomres(1) = 'E'
            call rcvalb(fami, kpg, 1, '+', zi(imate),&
                        ' ', 'ELAS', 0, ' ', [0.d0],&
                        1, nomres, valres, codres, 1)
            rig=valres(1)
!
! --- RAPH_MECA, FULL_MECA*, RIGI_MECA_* : ON PASSE PAR LA LDC 1D
!
        elseif (lNonLine) then
            sigm = zr(icontm+kpg-1)
!
!         CALCUL DE LA DEFORMATION DEPS11
            epsm=0.d0
            deps=0.d0
            do i = 1, nno
                do j = 1, nddl
                    epsm=epsm+b(j,i)*zr(ideplm+(i-1)*nddl+j-1)
                    deps=deps+b(j,i)*zr(ideplp+(i-1)*nddl+j-1)
                enddo
            enddo
!
            call nmco1d(fami, kpg, 1, zi(imate), rela_comp, rela_cpla,&
                        option, epsm, deps, angmas, sigm,&
                        zr(ivarim+(kpg-1)*lgpg), sig, zr( ivarip+(kpg-1)*lgpg), rig, cod(kpg))
!
            if (lSigm) then
                zr(icontp+kpg-1)=sig
            endif
        else
            ASSERT(ASTER_FALSE)
        endif
!
! --- RANGEMENT DES RESULTATS
!
        if (lVect) then
            do n = 1, nno
                do i = 1, nddl
                    zr(ivectu+(n-1)*nddl+i-1) = zr(ivectu+(n-1)*nddl+i-1) +&
                                                b(i,n)*sig*zr(ipoids+kpg-1)*jac*densit
                enddo
            enddo
        endif
!
        if (lMatr) then
            do n = 1, nno
                do i = 1, nddl
                    kkd = (nddl*(n-1)+i-1) * (nddl*(n-1)+i) /2
                    do j = 1, nddl
                        do m = 1, n
                            if (m .eq. n) then
                                j1 = i
                            else
                                j1 = nddl
                            endif
!
!                 RIGIDITE ELASTIQUE
                            tmp=b(i,n)*rig*b(j,m)*zr(ipoids+kpg-1)* jac*densit
!                 STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                            if (j .le. j1) then
                                kk = kkd + nddl*(m-1)+j
                                zr(imatuu+kk-1) = zr(imatuu+kk-1) + tmp
                            endif
                        enddo
                    enddo
                enddo
            enddo
        endif
!
! - FIN DE LA BOUCLE SUR LES POINTS DE GAUSS
    end do
!
    if (lSigm) then
        call codere(cod, npg, zi(jcret))
    endif
!
end subroutine
