! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine op0036()
    implicit none
!     ----- OPERATEUR CREA_TABLE              --------------------------
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/ctresu.h"
#include "asterfort/gettco.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/tbajco.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsv.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: iocc, ni, nr, nk, ir, jvale, jp, ndim, jt
    integer :: nocc, nocc2, nindi, iii, dimmax, jy, jlng,  jd
    integer :: jtrav1, jtrav2, jtrav3, jtrav4, jtrav5, jtrav6, npar
    integer :: nocc3, nco
    integer :: icol, ncol, nval, iligmax, ii, jj, length
    aster_logical :: is_list_co, is_tab_conteneur
    complex(kind=8) :: cbid
    character(len=1) :: kbid
    character(len=3) :: ntyp
    character(len=8) :: resu
    character(len=16) :: concep, nomcmd
    character(len=19) :: nfct
    character(len=24) :: trav, ldbl, indic, ltyp, work, typco, typtab
    character(len=24) :: vectcr, vectci, nmpar, nmpar1, nmparf(2), nmparc(3)
    integer :: ivcr, ivci
    character(len=24), pointer :: prol(:) => null()
    character(len=8), parameter :: typarr(2) = (/ 'R', 'R'/)
    character(len=8), parameter :: typarc(3) = (/ 'R', 'R', 'R'/)
!
!     ------------------------------------------------------------------
!
    cbid = dcmplx(0.d0, 0.d0)
    call jemarq()
!
    call getres(resu, concep, nomcmd)
    call getfac('LISTE', nocc)
    call getfac('FONCTION', nocc2)
    call getfac('RESU', nocc3)
!
    indic  ='&&OP0036.IND'
    trav   ='&&OP0036.VAL'
    ldbl   ='&&OP0036.DBL'
    ltyp   ='&&OP0036.TYP'
    work   ='&&OP0036.WOR'
!
!
!     ==========
! --- CAS: LISTE
!     ==========
    if (nocc .ne. 0) then
!       Calculer ncol le nombre de colonnes de la table
        ncol = 0 
!
!       Est-on en train de créer une table container ? 
        call getvtx(' ', 'TYPE_TABLE', scal=typtab )
        is_tab_conteneur = ( trim(typtab) == 'TABLE_CONTENEUR') 
!
        do iocc = 1, nocc
           call getvis('LISTE', 'LISTE_I', iocc=iocc, nbval=0, nbret=ni)
           call getvr8('LISTE', 'LISTE_R', iocc=iocc, nbval=0, nbret=nr)
           call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=0, nbret=nk)
           call getvid('LISTE', 'LISTE_CO', iocc=iocc, nbval=0, nbret=nco)
           if ( ni + nr + nk < 0 ) then 
              ncol = ncol + 1 
           else if ( nco < 0 ) then 
              ncol = ncol + 2
           endif 
        enddo
!
        call wkvect(work, 'V V I', iocc, jlng)
        call wkvect(ldbl, 'V V K24', ncol, jd)
        call wkvect(ltyp, 'V V K8', ncol, jy)

        dimmax=0
!
        icol = 0 
        do iocc = 1, nocc
            icol=icol+1
            call getvtx('LISTE', 'PARA', iocc=iocc, scal=nmpar, nbret=jp)
            call getvis('LISTE', 'LISTE_I', iocc=iocc, nbval=0, nbret=ni)
            call getvis('LISTE', 'NUME_LIGN', iocc=iocc, nbval=0, nbret=nindi)
            call getvr8('LISTE', 'LISTE_R', iocc=iocc, nbval=0, nbret=nr)
            call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=0, nbret=nk)
            call getvtx('LISTE', 'TYPE_K', iocc=iocc, scal=ntyp, nbret=jt)
            call getvid('LISTE', 'LISTE_CO', iocc=iocc, nbval=0, nbret=nco)
!           La liste courante est-elle une liste de concepts ? 
!           Si oui, on crée deux colonnes dans la table (nom_sd et type_concept)
!           Si non, on utilise le nom de paramètre fourni par l'utilisateur
            is_list_co=( nco < 0)
            if (is_list_co) then 
               if (.not. is_tab_conteneur) then 
                   call utmess('F','UTILITAI2_18')
               endif 
               zk24(jd+icol-1) = "NOM_SD"
               zk24(jd+icol+1-1) = "TYPE_OBJET"
            else 
               zk24(jd+icol-1) = nmpar
            endif 
!
!           Nombre de termes dans la liste fournie par l'utilisateur  (nval)
            nval=-ni-nr-nk-nco
            if (nindi .ne. 0) then
                if ((nval) .ne. (-nindi)) then
                    call utmess('F', 'UTILITAI2_75')
                endif
                call wkvect(indic, 'V V I', nval, iii)
                iligmax=0
                call getvis('LISTE', 'NUME_LIGN', iocc=iocc, nbval=nval, vect=zi(iii),&
                            nbret=ir)
                do ii = 1, nval
                    iligmax=max(iligmax,zi(iii+ii-1))
                end do
                call jedetr(indic)
                zi(jlng+icol-1)=iligmax
                if (is_list_co) then 
                    zi(jlng+icol+1-1)=iligmax
                endif 
            else
                zi(jlng+icol-1)=nval
                if (is_list_co) then 
                    zi(jlng+icol+1-1)=nval
                endif 
            endif
            dimmax=max(dimmax,zi(jlng+icol-1))
!
            if (ni .ne. 0) then
                zk8(jy+icol-1)='I'
            else if (nr.ne.0) then
                zk8(jy+icol-1)='R'
            else if (nk.ne.0) then
                if (ntyp(2:2) .eq. '8') then
                    zk8(jy+icol-1)='K8'
                else if (ntyp(2:2).eq.'1') then
                    zk8(jy+icol-1)='K16'
                else if (ntyp(2:2).eq.'2') then
                    zk8(jy+icol-1)='K24'
                endif
            else if (nco.ne.0) then 
                zk8(jy+icol-1)='K24'
                zk8(jy+icol+1-1)='K24'
            endif
!
            if (is_list_co) then
               icol=icol+1 
            endif 
        end do
!
!       Vérifier que les noms de paramètres sont uniques 
        
        do ii = 1, ncol
           nmpar1=zk24(jd+ii-1)
           do jj = 1, ncol
              nmpar=zk24(jd+jj-1)
              if ((nmpar.eq.nmpar1) .and. (jj.ne.ii)) then
                    call utmess('F', 'UTILITAI2_76', nk=1, valk=nmpar)
                endif
           enddo  
        enddo  
!       Si on a utilisé une liste de concepts pour créer une table_container,
!       vérifier que l'utilisateur a fourni une liste de paramètre "NOM_OBJET"
        if ( is_list_co ) then 
            if ( count(zk24(jd-1+1:jd-1+ncol)=="NOM_OBJET")/=1 ) then 
               call utmess('F', 'UTILITAI2_19')
            endif
        endif 
!
!       ---CREATION DE LA TABLE
        call tbcrsv(resu, 'G', ncol, zk24(jd), zk8(jy),&
                    dimmax)
!
        do iocc = 1, nocc
            call getvis('LISTE', 'LISTE_I', iocc=iocc, nbval=0, nbret=ni)
            call getvis('LISTE', 'NUME_LIGN', iocc=iocc, nbval=0, nbret=nindi)
            call getvr8('LISTE', 'LISTE_R', iocc=iocc, nbval=0, nbret=nr)
            call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=0, nbret=nk)
            call getvtx('LISTE', 'PARA', iocc=iocc, scal=nmpar, nbret=jp)
            call getvid('LISTE', 'LISTE_CO', iocc=iocc, nbval=0, nbret=nco)
            
!
            if (nindi .ne. 0) then
                nindi=-nindi
                call wkvect(indic, 'V V I', nindi, iii)
                call getvis('LISTE', 'NUME_LIGN', iocc=iocc, nbval=nindi, vect=zi(iii),&
                            nbret=ir)
            else
                call wkvect(indic, 'V V I', (-ni-nr-nk-nco), iii)
                do ii = 1, (-ni-nr-nk-nco)
                    zi(iii+ii-1)=ii
                end do
            endif
!
!           LISTE D'ENTIERS :
!           ---------------
            if (ni .ne. 0) then
                ni=-ni
                call wkvect(trav, 'V V I', ni, jtrav1)
                call getvis('LISTE', 'LISTE_I', iocc=iocc, nbval=ni, vect=zi(jtrav1),&
                            nbret=ir)
                call tbajco(resu, nmpar, 'I', ni, zi(jtrav1),&
                            [0.d0], [cbid], kbid, 'R', zi(iii))
            endif
!
!           LISTE DE REELS :
!           --------------
            if (nr .ne. 0) then
                nr=-nr
                call wkvect(trav, 'V V R', nr, jtrav2)
                call getvr8('LISTE', 'LISTE_R', iocc=iocc, nbval=nr, vect=zr(jtrav2),&
                            nbret=ir)
                call tbajco(resu, nmpar, 'R', nr, [0],&
                            zr(jtrav2), [cbid], kbid, 'R', zi(iii))
            endif
!
!           LISTE DE CHAINE DE CARACTERES :
!           -----------------------------
            if (nk .ne. 0) then
                nk=-nk
                call getvtx('LISTE', 'TYPE_K', iocc=iocc, scal=ntyp, nbret=jt)
!              CHAINES DE 8 CARACTERES
                if (ntyp(2:2) .eq. '8') then
                    call wkvect(trav, 'V V K8', nk, jtrav3)
                    call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=nk, vect=zk8(jtrav3),&
                                nbret=ir)
                    call tbajco(resu, nmpar, 'K8', nk, [0],&
                                [0.d0], [cbid], zk8(jtrav3), 'R', zi(iii))
!
!              CHAINES DE 16 CARACTERES
                else if (ntyp(2:2).eq.'1') then
                    call wkvect(trav, 'V V K16', nk, jtrav4)
                    call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=nk, vect=zk16(jtrav4),&
                                nbret=ir)
                    call tbajco(resu, nmpar, 'K16', nk, [0],&
                                [0.d0], [cbid], zk16(jtrav4), 'R', zi(iii))
!
!              CHAINES DE 24 CARACTERES
                else if (ntyp(2:2).eq.'2') then
                    call wkvect(trav, 'V V K24', nk, jtrav5)
                    call getvtx('LISTE', 'LISTE_K', iocc=iocc, nbval=nk, vect=zk24(jtrav5),&
                                nbret=ir)
                    call tbajco(resu, nmpar, 'K24', nk, [0],&
                                [0.d0], [cbid], zk24(jtrav5), 'R', zi(iii))
                endif
            endif
!
!           LISTE DE CONCEPTS :
!           ------------------
!           On ajoute 2 colonnes : TYPE_OBJET, NOM_SD 
!           L'utilisateur doit avoir fourni une colonne NOM_OBJET contenant une clé pour chaque 
!           concept de la liste donnée avec le mot-clé LIST_CO
            if ( nco .ne. 0 ) then 
                nco=-nco
                call wkvect(trav, 'V V K24', nco, jtrav6)
                call getvid('LISTE', 'LISTE_CO', iocc=iocc, nbval=nco, vect=zk24(jtrav6), &
                             nbret=ir)
                nmpar="NOM_SD"
                call tbajco(resu, nmpar, 'K24', nco, [0],&
                                [0.d0], [cbid], zk24(jtrav6), 'R', zi(iii))
                do ii = 1, nco
                   call gettco( zk24(jtrav6+ii-1), typco )
                   length=lxlgut(typco)
                   if (typco(length-7:length) == "_SDASTER") then 
                       typco=typco(1:length-8)
                   endif 
                   zk24(jtrav6+ii-1)=typco
                enddo 
                nmpar="TYPE_OBJET"
                call tbajco(resu, nmpar, 'K24', nco, [0],&
                                [0.d0], [cbid], zk24(jtrav6), 'R', zi(iii))
            endif 
            call jedetr(trav)
            call jedetr(indic)
        end do
!
!     ==============
! --- CAS : FONCTION
!     ==============
    else if (nocc2.ne.0) then
        call getvid('FONCTION', 'FONCTION', iocc=1, scal=nfct, nbret=ir)
!
        call jelira(nfct//'.VALE', 'LONMAX', ndim)
        call jeveuo(nfct//'.VALE', 'L', jvale)
        call jeveuo(nfct//'.PROL', 'L', vk24=prol)
!
        if (prol(1) .ne. 'FONCTION' .and. prol(1) .ne. 'CONSTANT' .and. prol(1)&
            .ne. 'FONCT_C') then
            call utmess('F', 'UTILITAI2_78', sk=nomcmd)
        endif
        call getvtx('FONCTION', 'PARA', iocc=1, nbval=2, vect=nmparf,&
                    nbret=ir)
        if (ir .eq. 0) then
            nmparf(1)=prol(3)(1:16)
            nmparf(2)=prol(4)(1:16)
        endif
        if (nmparf(1) .eq. nmparf(2)) then
            call utmess('F', 'UTILITAI2_79')
        endif
!
!       ---CAS CREATION D UNE NOUVELLE TABLE
!       ---
        if (prol(1) .eq. 'FONCT_C') then
            nmparc(1)=nmparf(1)
            npar =lxlgut(nmparf(2))
            nmparc(2)=nmparf(2)(1:npar)//'_R'
            nmparc(3)=nmparf(2)(1:npar)//'_I'
!
            call tbcrsv(resu, 'G', 3, nmparc, typarc,&
                        ndim/3)
            call tbajpa(resu, 3, nmparc, typarc)
            vectcr='&&OP0036.VCR'
            vectci='&&OP0036.VCI'
            call wkvect(vectcr, 'V V R', ndim/3, ivcr)
            call wkvect(vectci, 'V V R', ndim/3, ivci)
            do ii = 1, ndim/3
                zr(ivcr+ii-1)= zr(jvale-1+ndim/3+2*ii-1)
                zr(ivci+ii-1)= zr(jvale-1+ndim/3+2*ii)
            end do
            call tbajco(resu, nmparc(1), 'R', ndim/3, [0],&
                        zr(jvale), [cbid], kbid, 'R', [-1])
            call tbajco(resu, nmparc(2), 'R', ndim/3, [0],&
                        zr(ivcr), [cbid], kbid, 'R', [-1])
            call tbajco(resu, nmparc(3), 'R', ndim/3, [0],&
                        zr(ivci), [cbid], kbid, 'R', [-1])
            call jedetr(vectcr)
            call jedetr(vectci)
        else
            call tbcrsv(resu, 'G', 2, nmparf, typarr,&
                        ndim/2)
            call tbajpa(resu, 2, nmparf, typarr)
            call tbajco(resu, nmparf(1), 'R', ndim/2, [0],&
                        zr(jvale), [cbid], kbid, 'R', [-1])
            call tbajco(resu, nmparf(2), 'R', ndim/2, [0],&
                        zr(jvale+ndim/ 2), [cbid], kbid, 'R', [-1])
        endif
!
!     ==============
! --- CAS : RESU
!     ==============
    else if (nocc3.ne.0) then
!
        call ctresu(resu)
!
    endif
!
!
    call titre()
    call jedema()
!
end subroutine
