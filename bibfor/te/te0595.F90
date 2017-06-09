! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine te0595(option, nomte)
! person_in_charge: sebastien.fayolle at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/niinit.h"
#include "asterfort/nmtstm.h"
#include "asterfort/nofipd.h"
#include "asterfort/nufilg.h"
#include "asterfort/nufipd.h"
#include "asterfort/rcangm.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
! FONCTION REALISEE:  CALCUL DES FORCES INTERNES POUR LES ELEMENTS
!                     INCOMPRESSIBLES A 2 CHAMPS UP
!                     EN 3D/D_PLAN/AXI
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ----------------------------------------------------------------------
!
    aster_logical :: rigi, resi, mini, matsym
    integer :: ndim, nno1, nno2, npg, nnos, jgn, ntrou
    integer :: icoret, codret, iret
    integer :: iw, ivf1, ivf2, idf1, idf2
    integer :: jtab(7), lgpg, i, idim
    integer :: vu(3, 27), vg(27), vp(27), vpi(3, 27)
    integer :: igeom, imate, icontm, ivarim
    integer :: iinstm, iinstp, iddlm, iddld, icompo, icarcr
    integer :: ivectu, icontp, ivarip, imatuu
    integer :: idbg, nddl, ia, ja, ibid
    real(kind=8) :: angmas(7), bary(3)
    character(len=8) :: lielrf(10), typmod(2), alias8
    character(len=24) :: valk
! ----------------------------------------------------------------------
!
    idbg = 0
!
! - FONCTIONS DE FORMES ET POINTS DE GAUSS
    call elref2(nomte, 10, lielrf, ntrou)
    ASSERT(ntrou.ge.2)
    call elrefe_info(elrefe=lielrf(2), fami='RIGI', ndim=ndim, nno=nno2, nnos=nnos,&
                     npg=npg, jpoids=iw, jvf=ivf2, jdfde=idf2, jgano=jgn)
    call elrefe_info(elrefe=lielrf(1), fami='RIGI', ndim=ndim, nno=nno1, nnos=nnos,&
                     npg=npg, jpoids=iw, jvf=ivf1, jdfde=idf1, jgano=jgn)
    matsym = .true.
!
! - TYPE DE MODELISATION
    if (ndim .eq. 2 .and. lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS  '
    else if (ndim.eq.2 .and. lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN  '
    else if (ndim .eq. 3) then
        typmod(1) = '3D'
    else
        call utmess('F', 'ELEMENTS_34', sk=nomte)
    endif
    typmod(2) = '        '
    codret = 0
!
! - OPTION
    resi = option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL'
    rigi = option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL'
!
! - PARAMETRES EN ENTREE
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', iddlm)
    call jevech('PDEPLPR', 'L', iddld)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
!
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - ORIENTATION DU MASSIF
! - COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )
    bary(1) = 0.d0
    bary(2) = 0.d0
    bary(3) = 0.d0
    do i = 1, nno1
        do idim = 1, ndim
            bary(idim) = bary(idim)+zr(igeom+idim+ndim*(i-1)-1)/nno1
        end do
    end do
    call rcangm(ndim, bary, angmas)
!
! - PARAMETRES EN SORTIE
    if (resi) then
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
    else
        ivectu=1
        icontp=1
        ivarip=1
    endif
!
    if (zk16(icompo+2) (1:6) .eq. 'PETIT ') then
! - PARAMETRES EN SORTIE
        if (rigi) then
            call jevech('PMATUUR', 'E', imatuu)
        else
            imatuu=1
        endif
!
        if (lteatt('INCO','C2 ')) then
!
! - MINI ELEMENT ?
            call teattr('S', 'ALIAS8', alias8, ibid)
            if (alias8(6:8) .eq. 'TR3' .or. alias8(6:8) .eq. 'TE4') then
                mini = .true.
            else
                mini = .false.
            endif
!
! - ACCES AUX COMPOSANTES DU VECTEUR DDL
            call niinit(nomte, typmod, ndim, nno1, 0,&
                        nno2, 0, vu, vg, vp,&
                        vpi)
            nddl = nno1*ndim + nno2
!
            call nufipd(ndim, nno1, nno2, npg, iw,&
                        zr(ivf1), zr(ivf2), idf1, vu, vp,&
                        zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                        lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm),&
                        zr(iddld), angmas, zr(icontm), zr(ivarim), zr(icontp),&
                        zr(ivarip), resi, rigi, mini, zr(ivectu),&
                        zr(imatuu), codret)
        else if (lteatt('INCO','C2O')) then
! - ACCES AUX COMPOSANTES DU VECTEUR DDL
            call niinit(nomte, typmod, ndim, nno1, 0,&
                        nno2, nno2, vu, vg, vp,&
                        vpi)
            nddl = nno1*ndim + nno2 + nno2*ndim
!
            call nofipd(ndim, nno1, nno2, nno2, npg,&
                        iw, zr(ivf1), zr(ivf2), zr(ivf2), idf1,&
                        vu, vp, vpi, zr(igeom), typmod,&
                        option, nomte, zi(imate), zk16(icompo), lgpg,&
                        zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm), zr(iddld),&
                        angmas, zr(icontm), zr(ivarim), zr(icontp), zr(ivarip),&
                        resi, rigi, zr(ivectu), zr(imatuu), codret)
        else
            valk = zk16(icompo+2)
            call utmess('F', 'MODELISA10_17', sk=valk)
        endif
    else if (zk16(icompo+2) (1:8).eq.'GDEF_LOG') then
! - PARAMETRES EN SORTIE
        if (rigi) then
            call nmtstm(zr(icarcr), imatuu, matsym)
        else
            imatuu=1
        endif
!
        if (lteatt('INCO','C2 ')) then
!
! - MINI ELEMENT ?
            call teattr('S', 'ALIAS8', alias8, ibid)
            if (alias8(6:8) .eq. 'TR3' .or. alias8(6:8) .eq. 'TE4') then
! - PAS ENCORE INTRODUIT
                valk = zk16(icompo+2)
                call utmess('F', 'MODELISA10_18', sk=valk)
            endif
!
! - ACCES AUX COMPOSANTES DU VECTEUR DDL
            call niinit(nomte, typmod, ndim, nno1, 0,&
                        nno2, 0, vu, vg, vp,&
                        vpi)
            nddl = nno1*ndim + nno2
!
            call nufilg(ndim, nno1, nno2, npg, iw,&
                        zr(ivf1), zr(ivf2), idf1, vu, vp,&
                        zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                        lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm),&
                        zr(iddld), angmas, zr(icontm), zr(ivarim), zr(icontp),&
                        zr(ivarip), resi, rigi, zr(ivectu), zr(imatuu),&
                        matsym, codret)
!
        else
            valk = zk16(icompo+2)
            call utmess('F', 'MODELISA10_17', sk=valk)
        endif
    else
        call utmess('F', 'ELEMENTS3_16', sk=zk16(icompo+2))
    endif
!
    if (resi) then
        call jevech('PCODRET', 'E', icoret)
        zi(icoret) = codret
    endif
!
    if (idbg .eq. 1) then
        if (rigi) then
            write(6,*) 'MATRICE TANGENTE'
            do ia = 1, nddl
                write(6,'(108(1X,E11.4))') (zr(imatuu+(ia*(ia-1)/2)+ja-1),ja=1,ia)
            enddo
        endif
        if (resi) then
            write(6,*) 'FORCE INTERNE'
            write(6,'(108(1X,E11.4))') (zr(ivectu+ja-1),ja=1,nddl)
        endif
    endif
!
end subroutine
